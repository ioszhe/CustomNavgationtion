//
//  UIFramework.swift
//  CustomNavgationtion
//
//  Created by ioszhe on 14-11-6.
//  Copyright (c) 2014年 lenovo. All rights reserved.
//

import UIKit
enum UIViewId: Int{
    case Empty = 0, Index
}
enum UIAnimationId: Int{
    case Empty = 0, Fade, Push, Pop, StackPush, StackPop
}

class ViewInfo: NSObject{
    var viewController: UIViewController!
    var viewId: UIViewId!
    init(viewController: UIViewController, viewId: UIViewId) {
        super.init()
        self.viewController = viewController
        self.viewId = viewId
    }
    
    deinit{
        self.viewController = nil
    }
}
extension UIViewController{
    func naviLeftButton(naviBar: AnyObject) {
        
    }
    func naviRightButton(naviBar: AnyObject) {
        
    }
}

class UIFramework: UIViewController {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var viewArray = [ViewInfo]()
    override init() {
        super.init()
    }

    func addController(viewInfo: ViewInfo){
        viewArray.append(viewInfo)
    }
    
    func addController(controler: UIViewController, viewId: UIViewId){
        let info = ViewInfo(viewController: controler, viewId: viewId)
        self.addController(info)
    }
    
    func removeController(viewInfo: ViewInfo){
        for idx in 0..<viewArray.count {
            let info = viewArray[idx]
            if info.viewId == viewInfo.viewId{
                viewArray.removeAtIndex(idx)
                break
            }
        }
    }
    func isExistViewInfo(viewId: UIViewId) -> ViewInfo?{
        for idx in 0..<viewArray.count {
            let info = viewArray[idx]
            if info.viewId == viewId{
                return info
            }
        }
        return nil
    }
    
    func getTopViewInfo() -> ViewInfo?{
        if viewArray.count > 0{
            return viewArray.last
        }
        return nil
    }
    
    func getTopViewLowerInfo() -> ViewInfo?{
        if viewArray.count > 1{
            return viewArray[viewArray.count - 1]
        }
        return nil
    }
    
    deinit{
        viewArray.removeAll(keepCapacity: false)
    }
    
    func removeAllInfos() {
        viewArray.removeAll(keepCapacity: true)
    }
}
