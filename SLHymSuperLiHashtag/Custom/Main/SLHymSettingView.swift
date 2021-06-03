//
//  SLHymSettingView.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/24.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit

let AppName: String = "Smart tags"
let purchaseUrl = ""
let TermsofuseURLStr = "http://erect-agreement.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://deserted-boundary.surge.sh/Privacy_Agreement.html"

let feedbackEmail: String = "juunybansicer@yandex.com"
let AppAppStoreID: String = ""



class SLHymSettingView: UIView {
    var upVC: SLHymMainVC?
    
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    let logoutBtn = UIButton(type: .custom)
    let userNameLabel = UILabel()
    let userIconImgV = UIImageView(image: UIImage(named: "user_profile_ic"))
    var showLoginViewBlock: (()->Void)?
    var backBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateUserAccountStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SLHymSettingView {
    func setupView() {
        backgroundColor = .clear
        //
        let bgBtn = UIButton(type: .custom)
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(bgBtnClick(sender:)), for: .touchUpInside)
        //
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = .white
        addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-450)
        }
        bottomBgView.layer.cornerRadius = 32
        //
        let bottomOverView = UIView()
        bottomOverView.backgroundColor = .white
        addSubview(bottomOverView)
        bottomOverView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(40)
        }
        //
        
        let backBtn = UIButton(type: .custom)
        bottomBgView.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(bgBtnClick(sender:)), for: .touchUpInside)
        //
        let backLine = UIView()
        backLine.isUserInteractionEnabled = false
        backLine.backgroundColor = UIColor(hexString: "#D8D8D8")
        backBtn.addSubview(backLine)
        backLine.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(4)
        }
        backLine.layer.cornerRadius = 2
        //
        // user icon imgV
        bottomBgView.addSubview(userIconImgV)
        userIconImgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(34)
            $0.width.height.equalTo(36)
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
        }
        userIconImgV.contentMode = .scaleAspectFit
        
        
        // user name label
        bottomBgView.addSubview(userNameLabel)
        userNameLabel.textAlignment = .center
        userNameLabel.text = ""
        userNameLabel.textColor = UIColor(hexString: "#68523E")
        userNameLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userIconImgV)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(35)
            $0.left.equalTo(userIconImgV.snp.right).offset(15)
        }
        
        // login
        loginBtn.setTitleColor(UIColor(hexString: "#68523E"), for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        loginBtn.setTitle("Click to Login", for: .normal)
        loginBtn.backgroundColor = .clear
//        loginBtn.layer.cornerRadius = 25
//        loginBtn.layer.borderWidth = 4
//        loginBtn.layer.borderColor = UIColor.black.cgColor
        
        bottomBgView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.centerY.equalTo(userIconImgV)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(35)
            $0.left.equalTo(userIconImgV.snp.right).offset(15)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        //
        let loginBtnLine = UIView()
        loginBtnLine.backgroundColor = UIColor(hexString: "#68523E")
        loginBtn.addSubview(loginBtnLine)
        loginBtnLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        // feedbackBtn
        feedbackBtn.backgroundColor = .clear
        feedbackBtn.layer.cornerRadius = 6
        feedbackBtn.backgroundColor = UIColor(hexString: "#F8EEE6")
        feedbackBtn.setTitleColor(UIColor(hexString: "#68523E"), for: .normal)
        feedbackBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        feedbackBtn.setImage(UIImage(named: "settingItem_ic"), for: .normal)
        feedbackBtn.contentHorizontalAlignment = .left
        feedbackBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        feedbackBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        feedbackBtn.setTitle("Feedback", for: .normal)
        bottomBgView.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalTo(26)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userIconImgV.snp.bottom).offset(30)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        // privacyBtn
        privacyBtn.backgroundColor = .clear
        privacyBtn.layer.cornerRadius = 6
        privacyBtn.backgroundColor = UIColor(hexString: "#F8EEE6")
        privacyBtn.setTitleColor(UIColor(hexString: "#68523E"), for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        privacyBtn.setImage(UIImage(named: "settingItem_ic"), for: .normal)
        privacyBtn.contentHorizontalAlignment = .left
        privacyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        privacyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        bottomBgView.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalTo(26)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(20)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        // termsBtn
        termsBtn.backgroundColor = .clear
        termsBtn.layer.cornerRadius = 6
        termsBtn.backgroundColor = UIColor(hexString: "#F8EEE6")
        termsBtn.setTitleColor(UIColor(hexString: "#68523E"), for: .normal)
        termsBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        termsBtn.setImage(UIImage(named: "settingItem_ic"), for: .normal)
        termsBtn.contentHorizontalAlignment = .left
        termsBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        termsBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        termsBtn.setTitle("Term of use", for: .normal)
        bottomBgView.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalTo(26)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(20)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
        //
        //
        // log out
        logoutBtn.layer.cornerRadius = 6
        logoutBtn.backgroundColor = UIColor(hexString: "#F8EEE6")
        logoutBtn.setTitleColor(UIColor(hexString: "#68523E"), for: .normal)
        logoutBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        logoutBtn.setImage(UIImage(named: "settingItem_ic"), for: .normal)
        logoutBtn.setTitle("Log out", for: .normal)
        logoutBtn.contentHorizontalAlignment = .left
        logoutBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        logoutBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        

        
        bottomBgView.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalTo(26)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(termsBtn.snp.bottom).offset(20)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
    }
    
    
    
}

extension SLHymSettingView {
    
    @objc func bgBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    @objc func logoutBtnClick(sender: UIButton) {
        LoginManage.shared.logout()
        updateUserAccountStatus()
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            showLoginViewBlock?()
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginManage.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Tourist"
            userNameLabel.isHidden = false
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
//            userIconImgV.isHidden = false
//            privacyBtn.snp.remakeConstraints {
//                $0.width.equalTo(155)
//                $0.height.equalTo(45)
//                $0.centerX.equalToSuperview()
//                $0.bottom.equalTo(loginBtn.snp.top).offset(-32)
//            }
        } else {
            userNameLabel.text = ""
            userNameLabel.isHidden = true
//            userIconImgV.isHidden = true
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
//            privacyBtn.snp.remakeConstraints {
//                $0.width.equalTo(155)
//                $0.height.equalTo(45)
//                $0.centerX.equalToSuperview()
//                $0.bottom.equalTo(loginBtn.snp.top).offset(-64)
//            }
        }
    }
}

extension SLHymSettingView: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.upVC?.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}

extension UIDevice {
  
   ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
   var modelName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
      
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8, value != 0 else {
               return identifier
           }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
      
       switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
           case "iPhone4,1":                               return "iPhone 4s"
           case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
           case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
           case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
           case "iPhone7,2":                               return "iPhone 6"
           case "iPhone7,1":                               return "iPhone 6 Plus"
           case "iPhone8,1":                               return "iPhone 6s"
           case "iPhone8,2":                               return "iPhone 6s Plus"
           case "iPhone8,4":                               return "iPhone SE"
           case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
           case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
           case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6":                return "iPhone X"
           case "iPhone11,2":                              return "iPhone XS"
           case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
           case "iPhone11,8":                              return "iPhone XR"
           case "iPhone12,1":                              return "iPhone 11"
           case "iPhone12,3":                              return "iPhone 11 Pro"
           case "iPhone12,5":                              return "iPhone 11 Pro Max"
           case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
           case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
           case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
           case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
           case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
           case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
           case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
           case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
           case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
           case "AppleTV5,3":                              return "Apple TV"
           case "i386", "x86_64":                          return "Simulator"
           default:                                        return identifier
       }
   }
}
