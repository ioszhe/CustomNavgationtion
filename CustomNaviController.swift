//
//  CustomNaviController.swift
//  CustomNavgationtion
//
//  Created by ioszhe on 14-11-6.
//  Copyright (c) 2014年 lenovo. All rights reserved.
//

import UIKit
protocol CustomNaviProtocol: NSObjectProtocol{
    func naviLeftButton(naviBar: AnyObject)
    func naviRightButton(naviBar: AnyObject)
    func canDragBack() -> Bool
}


let CustomNaviWidth = UIScreen.mainScreen().bounds.width
let CustomNaviHeight = UIScreen.mainScreen().bounds.height

let CustomNaviLeftOffset = CustomNaviWidth/2
class CustomNaviController: UIFramework, CustomNaviBarProtocol, UIGestureRecognizerDelegate {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var screenShotsList = [UIImage]()
    var canDragBack = true
    var animationDuration = 0.3
    var contentView: UIView!
    let viewFrame = UIScreen.mainScreen().bounds
    var navi_bar: CustomNaviBar!
    var recognizer: UIPanGestureRecognizer!
    
    var rootViewController: UIViewController!
    var currViewController: UIViewController!
    
    var lastScreenShotView: UIImageView!
    
    init(controller: UIViewController, viewId: UIViewId) {
        super.init()
        self.view.frame = viewFrame
        self.contentView = UIView(frame: CGRectMake(0, CustomNaviBarHeight, viewFrame.width, viewFrame.height))
        self.view.addSubview(contentView)
        self.navi_bar = CustomNaviBar(frame: CGRectMake(0, 0, viewFrame.width, CustomNaviBarHeight), delegate: self)
        
        self.recognizer = UIPanGestureRecognizer()
        recognizer.delegate = self
        //recognizer.enabled = false
        self.view.addGestureRecognizer(recognizer)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastScreenShotView = UIImageView(frame: viewFrame)
        self.view.addSubview(lastScreenShotView)
        // Do any additional setup after loading the view.
    }
    func changeRootViewController(aViewController: UIViewController?, aViewId: UIViewId){
        if self.getTopViewInfo()?.viewId == aViewId{
            //重复
            return
        }
        //清空子view
        for con in self.childViewControllers{
            con.removeFromParentViewController()
        }
        var tCon = aViewController
        if tCon == nil{
           tCon = self.getViewController(aViewId)
        }else{
            
        }
        self.rootViewController = tCon
        self.addChildViewController(rootViewController)
        rootViewController.view.frame = contentView.bounds
        
        self.currViewController = rootViewController
        self.addController(rootViewController, viewId: aViewId)
    }
    
    func getViewController(aViewId: UIViewId) -> UIViewController{
        var toViewController: UIViewController
        var isExistView = self.isExistViewInfo(aViewId)
        if isExistView == nil{
            switch aViewId{
            case .Empty:
                NSLog("Empty")
                toViewController = UIViewController()
            case .Index:
                NSLog("Index")
                toViewController = UIViewController()
            }
        }else{
            toViewController = isExistView!.viewController
        }
        return toViewController
    }
    
    func switchView(aViewId: UIViewId, aDelete: Bool, aAid: UIAnimationId){
        let isExistView = self.isExistViewInfo(aViewId)
        if isExistView != nil{
            return
        }
        var toViewController: UIViewController!
        let lastScreenShot = self.capture()
        screenShotsList.append(lastScreenShot)
        
        toViewController = self.getViewController(aViewId)
        self.addChildViewController(toViewController)
        
    }
    var animationView: UIView!
    func transitionViewController(aFromViewController: UIViewController, toViewController: UIViewController, aAid: UIAnimationId){
        let from = aFromViewController; let to = toViewController
        animationView = self.view
        var shotRect = lastScreenShotView.frame
        shotRect.origin.y = self.view.frame.origin.y
        lastScreenShotView.frame = shotRect
        var animationType = UIViewAnimationOptions.TransitionNone
        var animationStart = {() -> Void in }
        var animationEnd = {(finished: Bool) -> Void in }
        
        var duation = animationDuration
        switch aAid{
        case .Push:
            to.view.frame = CGRectMake(CustomNaviWidth, 0, CustomNaviWidth, CustomNaviHeight)
            animationStart = {() -> Void in
                from.view.frame = CGRectMake(-CustomNaviWidth, 0, CustomNaviWidth, CustomNaviHeight)
                to.view.frame = CGRectMake(0, 0, CustomNaviWidth, CustomNaviHeight);
            }
            animationEnd = {(finished) in
                if (finished) {
                    from.view.frame = CGRectMake(0, 0, CustomNaviWidth, CustomNaviHeight);
                }
            }
        case .Pop:
            to.view.frame = CGRectMake(-CustomNaviWidth, 0, CustomNaviWidth, CustomNaviHeight)
            animationStart = {() -> Void in
                from.view.frame = CGRectMake(CustomNaviWidth, 0, CustomNaviWidth, CustomNaviHeight)
                to.view.frame = CGRectMake(0, 0, CustomNaviWidth, CustomNaviHeight);
            }
            animationEnd = {(finished) in
                if (finished) {
                    to.view.frame = CGRectMake(0, 0, CustomNaviWidth, CustomNaviHeight);
                }
            }
        case .StackPush:
            lastScreenShotView.hidden = false
            animationView.superview?.insertSubview(lastScreenShotView, belowSubview: animationView)
            lastScreenShotView.image = screenShotsList.last
            lastScreenShotView.transform = CGAffineTransformMakeTranslation(0, 0)
            animationView.transform = CGAffineTransformMakeTranslation(CustomNaviWidth, 0)
            animationStart = {() -> Void in
                self.lastScreenShotView.transform = CGAffineTransformMakeTranslation(-CustomNaviLeftOffset, 0)
                self.animationView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            animationEnd = {(finished) in
                if (finished) {
                    self.lastScreenShotView.hidden = true
                    //to.view.frame = CGRectMake(0, 0, width, height);
                }
            }
        case .StackPop:
            let outImg = self.capture()
            lastScreenShotView.hidden = false
            animationView.superview?.insertSubview(lastScreenShotView, belowSubview: animationView)
            animationView.hidden = true
            lastScreenShotView.image = screenShotsList.last
            
            let moveOutView = UIImageView(image: outImg)
            var shotRect = lastScreenShotView.frame
            shotRect.origin.x = 0
            moveOutView.frame = shotRect
            animationView.superview?.addSubview(moveOutView)
            
            lastScreenShotView.transform = CGAffineTransformMakeTranslation(-CustomNaviLeftOffset, 0)
            animationView.transform = CGAffineTransformMakeTranslation(0, 0)
            animationStart = {() -> Void in
                moveOutView.transform = CGAffineTransformMakeTranslation(CustomNaviWidth, 0)
                self.lastScreenShotView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            animationEnd = {(finished) in
                if (finished) {
                    self.lastScreenShotView.hidden = true
                    self.animationView.hidden = false
                    moveOutView.removeFromSuperview()
                    self.screenShotsList.removeLast()
                    //self.goRecover()
                }
            }
        case .Fade:
            var _rect = CGRectMake(0, 0, CustomNaviWidth, CustomNaviHeight)
            to.view.frame = _rect
            from.view.frame = _rect
            duation = 0.8
            animationType = UIViewAnimationOptions.TransitionCrossDissolve
        default:
            NSLog("defalult")
        }
        
        self.transitionFromViewController(from, toViewController: to, duration: duation, options: animationType, animations: animationStart, completion: animationEnd)
    }
    
    // MARK: - get the current view screen shot
    func capture() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.layer.contents = nil
        return img
    }
    // MARK: - button
    override func naviLeftButton(naviBar: AnyObject) {
        if currViewController.respondsToSelector("naviLeftButton:"){
            currViewController.naviLeftButton(self)
        }
    }
    override func naviRightButton(naviBar: AnyObject) {
        if currViewController.respondsToSelector("naviRightButton:"){
            currViewController.naviRightButton(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
