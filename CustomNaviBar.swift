//
//  CustomNaviBar.swift
//  CustomNavgationtion
//
//  Created by ioszhe on 14-11-6.
//  Copyright (c) 2014年 lenovo. All rights reserved.
//

import UIKit
enum NaviBarTpye: Int{
    case Normal = 0, White
}

protocol CustomNaviBarProtocol: NSObjectProtocol{
    func naviLeftButton(naviBar: AnyObject)
    func naviRightButton(naviBar: AnyObject)
}
let CustomNaviBarHeight: CGFloat = 64
class CustomNaviBar: UIView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var delegate: CustomNaviBarProtocol?
    var left_btn: UIButton!
    var right_btn: UIButton!
    var titleLbl: UILabel!
    
    init(frame: CGRect, delegate: CustomNaviBarProtocol?) {
        self.delegate = delegate
        super.init(frame: frame)
        let btnFont = UIFont.systemFontOfSize(14)
        self.left_btn = UIButton.buttonWithType(.Custom) as UIButton
        left_btn.frame = CGRectMake(0, 0, CustomNaviBarHeight, CustomNaviBarHeight)
        left_btn.titleLabel?.font = btnFont
        left_btn.addTarget(self, action: "pressButton:", forControlEvents: .TouchUpInside)
        self.addSubview(left_btn)
        
        self.right_btn = UIButton.buttonWithType(.Custom) as UIButton
        right_btn.frame = CGRectMake(frame.width-CustomNaviBarHeight, 0, CustomNaviBarHeight, CustomNaviBarHeight)
        right_btn.titleLabel?.font = btnFont
        right_btn.addTarget(self, action: "pressButton:", forControlEvents: .TouchUpInside)
        self.addSubview(right_btn)
        
        self.titleLbl = UILabel(frame: CGRectMake(CustomNaviBarHeight, 0, frame.width - 2*CustomNaviBarHeight, CustomNaviBarHeight))
        titleLbl.font = btnFont
        titleLbl.backgroundColor = UIColor.clearColor()
        titleLbl.textAlignment = .Center
        self.addSubview(titleLbl)
    }

    var naviBarType: NaviBarTpye!{
        willSet{
            if newValue != naviBarType{
                //处理不同类型
                
            }
        }
    }
    
    
    
    func setLeftBtn(normalImg: String, activeImg: String){
        left_btn.setImage(UIImage(named: normalImg), forState: .Normal)
        left_btn.setImage(UIImage(named: activeImg), forState: .Highlighted)
    }
    func setRightBtn(normalImg: String, activeImg: String){
        right_btn.setImage(UIImage(named: normalImg), forState: .Normal)
        right_btn.setImage(UIImage(named: activeImg), forState: .Highlighted)
    }
    func setNaviTitle(title: String?){
        titleLbl.text = title
    }
    func setRightTxt(txt: String?){
        right_btn.setTitle(txt, forState: .Normal)
    }
    func setBgColorImg(img: UIImage){
        self.backgroundColor = UIColor(patternImage: img)
    }
    func pressButton(btn: UIButton){
        if btn == left_btn{
            delegate?.naviLeftButton(self)
        }else if btn == right_btn{
            delegate?.naviRightButton(self)
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
