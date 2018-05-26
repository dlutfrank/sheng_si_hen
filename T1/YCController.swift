//
//  Controller.swift
//  T1
//
//  Created by Rong GONG on 16/02/2017.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import Foundation
import UIKit

class YCController: UIView {
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    var color_white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var color_orange = UIColor(red: 238.0/255.0, green: 145.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    var font_size_unselect = CGFloat(13)
    var font_size_select = CGFloat(15)
    var font_size_jumpback = CGFloat(18)
    
    var btn_names = Array<String>()
    
    let dict_icon_btn = ["overview": "大全",
                         "fullview": "全景",
                         "close": "近景",
                         "left": "左",
                         "right": "右",
                         "teacher": "老师",
                         "student": "学生",
                         "band": "乐队",
                         "feet": "脚"] as [AnyHashable : String]
    
    func resetBtnImages(btn_names: Array<String>) {
        self.btn_names = btn_names
        
        btn6.setTitleColor(color_white, for: .normal)
        btn6.titleLabel?.font = UIFont.boldSystemFont(ofSize: font_size_jumpback)
        btn6.contentHorizontalAlignment = .left
        btn6.contentVerticalAlignment = .center
        btn6.setBackgroundImage(UIImage(named: "jumpback_white_wide"), for: .normal)
        btn6.isHidden = true
        
        btn0.setTitleColor(color_white, for: .normal)
        btn0.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
        btn0.contentHorizontalAlignment = .right
        btn0.contentVerticalAlignment = .bottom
        btn0.setBackgroundImage(UIImage(named: btn_names[0]+"_noline"), for: .normal)
        btn0.setTitle(dict_icon_btn[btn_names[0]],for: .normal)
        
        btn1.setTitleColor(color_white, for: .normal)
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
        btn1.contentHorizontalAlignment = .right
        btn1.contentVerticalAlignment = .bottom
        btn1.setBackgroundImage(UIImage(named: btn_names[1]+"_noline"), for: .normal)
        btn1.setTitle(dict_icon_btn[btn_names[1]],for: .normal)
        
        btn2.setTitleColor(color_white, for: .normal)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
        btn2.contentHorizontalAlignment = .right
        btn2.contentVerticalAlignment = .bottom
        btn2.setBackgroundImage(UIImage(named: btn_names[2]+"_noline"), for: .normal)
        btn2.setTitle(dict_icon_btn[btn_names[2]],for: .normal)
        
        btn3.setTitleColor(color_white, for: .normal)
        btn3.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
        btn3.contentHorizontalAlignment = .right
        btn3.contentVerticalAlignment = .bottom
        btn3.setBackgroundImage(UIImage(named: btn_names[3]+"_noline"), for: .normal)
        btn3.setTitle(dict_icon_btn[btn_names[3]],for: .normal)
        
        if btn_names.count > 4 {
            btn4.setTitleColor(color_white, for: .normal)
            btn4.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
            btn4.contentHorizontalAlignment = .right
            btn4.contentVerticalAlignment = .bottom
            btn4.setBackgroundImage(UIImage(named: btn_names[4]+"_noline"), for: .normal)
            btn4.setTitle(dict_icon_btn[btn_names[4]],for: .normal)
        } else {
            btn4.isHidden = true
        }
        
        if btn_names.count > 5 {
            btn5.setTitleColor(color_white, for: .normal)
            btn5.titleLabel?.font = UIFont.systemFont(ofSize: font_size_unselect)
            btn5.contentHorizontalAlignment = .right
            btn5.contentVerticalAlignment = .bottom
            btn5.setBackgroundImage(UIImage(named: btn_names[5]+"_noline"), for: .normal)
            btn5.setTitle(dict_icon_btn[btn_names[5]],for: .normal)
        } else {
            btn5.isHidden = true
        }
    }
    
    func setBtn0Image(image_name: String) {
        btn0.setTitleColor(color_orange, for: .normal)
        btn0.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn0.contentHorizontalAlignment = .right
        btn0.contentVerticalAlignment = .top
        btn0.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn0(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":0])
        
        setBtn0Image(image_name: self.btn_names[0])
    }
    
    func setBtn1Image(image_name: String) {
        btn1.setTitleColor(color_orange, for: .normal)
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn1.contentHorizontalAlignment = .right
        btn1.contentVerticalAlignment = .top
        btn1.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn1(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":1])
        
        setBtn1Image(image_name: self.btn_names[1])
    }
    
    func setBtn2Image(image_name: String) {
        btn2.setTitleColor(color_orange, for: .normal)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn2.contentHorizontalAlignment = .right
        btn2.contentVerticalAlignment = .top
        btn2.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn2(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":2])
        
        setBtn2Image(image_name: self.btn_names[2])
    }

    func setBtn3Image(image_name: String) {
        btn3.setTitleColor(color_orange, for: .normal)
        btn3.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn3.contentHorizontalAlignment = .right
        btn3.contentVerticalAlignment = .top
        btn3.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn3(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":3])
        
        setBtn3Image(image_name: self.btn_names[3])
    }
    
    func setBtn4Image(image_name: String) {
        btn4.setTitleColor(color_orange, for: .normal)
        btn4.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn4.contentHorizontalAlignment = .right
        btn4.contentVerticalAlignment = .top
        btn4.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn4(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":4])
        
        setBtn4Image(image_name: self.btn_names[4])
    }
    
    func setBtn5Image(image_name: String){
        btn5.setTitleColor(color_orange, for: .normal)
        btn5.titleLabel?.font = UIFont.systemFont(ofSize: font_size_select)
        btn5.contentHorizontalAlignment = .right
        btn5.contentVerticalAlignment = .top
        btn5.setBackgroundImage(UIImage(named: image_name+"_line"), for: .normal)
    }
    
    @IBAction func playBtn5(_ sender: Any) {
        resetBtnImages(btn_names: self.btn_names)
        
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":5])
        
        setBtn5Image(image_name: self.btn_names[5])
    }
    
    @IBAction func jumpVideoBtn(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name("jump2JXVideo"),
                                        object: nil,
                                        userInfo: nil)
        print("jumpVideoBtn clicked!")
    }
    
}
