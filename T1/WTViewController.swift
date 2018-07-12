//
//  WTViewController.swift
//  sheng_si_hen
//
//  Created by Rong GONG on 27/06/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import UIKit
import paper_onboarding

class WTViewController: UIViewController {
    
    private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "WT03"),
                           title: "公开",
                           description: "学术论文和视频公开为非商业研究所用，Creative Commons Attribution-NonCommercial 4.0授权。您可以通过此链接（https://doi.org/10.5281/zenodo.1299208）下载所有视频。",
                           pageIcon: #imageLiteral(resourceName: "close_noline"),
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "WT01"),
                           title: "《生死恨》",
                           description: "梅派第三代传人，中国戏曲学院教授 - 张晶亲自讲授并表演此剧目。",
                           pageIcon: #imageLiteral(resourceName: "close_noline"),
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "WT04"),
                           title: "练习",
                           description: "跟随京胡伴奏练习经典唱段《耳边厢又听得初更鼓响》",
                           pageIcon: #imageLiteral(resourceName: "close_noline"),
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "WT02"),
                           title: "多视角教学和演出视频",
                           description: "您可以从多个摄像机视角观看教学和演出视频，全面掌握剧目的关键演唱和动作。",
                           pageIcon: #imageLiteral(resourceName: "close_noline"),
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        skipButton.isHidden = true
        setupPaperOnboardingView()
        view.bringSubview(toFront: skipButton)
        view.bringSubview(toFront: practiceButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "navigationSegue", sender: self)
    }
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "practiceSegue", sender: self)
    }
}
// MARK: PaperOnboardingDelegate

extension WTViewController: PaperOnboardingDelegate {
    
    public func onboardingWillTransitonToIndex(_ index: Int) {
//        skipButton.isHidden = index == 2 ? false : true
    }
    
    public func onboardingDidTransitonToIndex(_: Int) {
    }
    
    public func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension WTViewController: PaperOnboardingDataSource {
    
    public func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    public func onboardingItemsCount() -> Int {
        return 4
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}
