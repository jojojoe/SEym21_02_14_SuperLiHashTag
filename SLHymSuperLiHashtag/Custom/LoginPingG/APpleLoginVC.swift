//
//  APpleLoginVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/21.
//

import Foundation

import UIKit
import FirebaseAuth
import FirebaseUI
import Firebase
import AuthenticationServices
import DeviceKit
import SnapKit
import SwifterSwift

class APpleLoginVC: FUIAuthPickerViewController, FUIAuthDelegate {
    var coinAlertCloseBtnClickBlock: (()->Void)?
    
    let ppUrl = "http://late-language.surge.sh/Privacy_Agreement.htm"
    let touUrl = "http://late-language.surge.sh/Terms_of_use.htm"
    
    let def_fontName = ""
    let coinAlertBottomView = UIView()
    let label = UILabel()
    var loginCompletionBlock: (()->Void)?
    
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var buttons: [UIButton] = []
    var collection: UICollectionView!
    let bgImageView = UIImageView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findButtons(subView: self.view)
        setupBottomView()
        setupView()
        
    }
    
    func findButtons(subView: UIView) {
        
        if subView.isKind(of: UIButton.classForCoder()) {
            
            if let button = subView as? UIButton {
                buttons.append(button)
            }
            return
        } else {
            subView.backgroundColor = .clear
        }
        
        for sv in subView.subviews {
            findButtons(subView: sv)
        }
    }
    
    @objc func closebuttonClick(button: UIButton) {
        coinAlertCloseBtnClickBlock?()
//        self.dismiss(animated: true) {
//        }
    }
    
    @objc func appleButtonClick(button: UIButton) {
        let requestID = ASAuthorizationAppleIDProvider().createRequest()
                // 这里请求了用户的姓名和email
                requestID.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [requestID])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
    }
    
    func customFont(fontName: String, size: CGFloat) -> UIFont {
        let stringArray: Array = fontName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: stringArray[0], ofType: stringArray[1])
        let fontData = NSData.init(contentsOfFile: path ?? "")
        
        let fontdataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
        let fontRef = CGFont.init(fontdataProvider!)!
        
        var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
        CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
        
        let fontName: String =  fontRef.postScriptName as String? ?? ""
        let font = UIFont(name: fontName, size: size)
        
        fontError?.release()
        
        return font ?? UIFont(name: def_fontName, size: size)!
    }
    
    @objc func buttonClick(button: UIButton) {
        
        switch button.tag {
            
        case 1001:
            let url = URL(string: ppUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
            
        case 1002:
            let url = URL(string: touUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break

        default:
            break
        }
    }
 
}

extension APpleLoginVC {
    
    func setupBottomView() {
        
        view.backgroundColor = .white
        //
        let bgImgV = UIImageView(image: UIImage(named: "log_in_pic"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let iconImgV = UIImageView(image: UIImage(named: "launchtag"))
        iconImgV.contentMode = .scaleAspectFit
        view.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.width.height.equalTo(100)
        }
        //
        
        //
       
        
        view.addSubview(coinAlertBottomView)
        coinAlertBottomView.backgroundColor = .clear
        coinAlertBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        //

//        label.font = UIFont(name: "Lexend-ExtraBold", size: 16)
//        label.textColor = UIColor(hexString: "#232323")
//        label.text = "Login"
//        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        coinAlertBottomView.addSubview(label)
//        label.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(39)
//            $0.height.equalTo(44)
//            $0.width.greaterThanOrEqualTo(1)
//        }
         
        //
        let closeBtn = UIButton(type: .custom)
        view.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "close_ic"), for: .normal)
        closeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-4)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-8)
            $0.width.height.equalTo(44)
        }
        closeBtn.addTarget(self, action: #selector(coinAlertCloseBtnClick(sender:)), for: .touchUpInside)
        //
         
    }
    
    @objc func coinAlertCloseBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
//        coinAlertCloseBtnClickBlock?()
    }
    
    func setupView() {
        
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        appleButton.addTarget(self, action: #selector(appleButtonClick(button:)), for: .touchUpInside)
        appleButton.layer.masksToBounds = true
        appleButton.layer.borderColor = UIColor(hexString: "#DFDFDF")!.cgColor
        appleButton.layer.borderWidth = 1
        appleButton.layer.cornerRadius = 24
//        self.view.addSubview(appleButton)
        coinAlertBottomView.addSubview(appleButton)
        appleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(48)
            make.centerX.equalTo(self.view)
            make.top.equalTo(24)
            
        }
        
        let googleButton = buttons[0]
        googleButton.layer.cornerRadius = 24
        googleButton.layer.masksToBounds = true
        googleButton.setTitle(" Sign in with Google", for: .normal)
        googleButton.setTitleColor(.black, for: .normal)
        googleButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        googleButton.frame = CGRect.zero
        googleButton.backgroundColor = .white
        googleButton.contentHorizontalAlignment = .center
        googleButton.layer.masksToBounds = true
//        self.view.addSubview(googleButton)
        googleButton.layer.borderColor = UIColor(hexString: "#DFDFDF")!.cgColor
        googleButton.layer.borderWidth = 1
        coinAlertBottomView.addSubview(googleButton)
        googleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(48)
            make.centerX.equalTo(self.view)
            make.top.equalTo(appleButton.snp.bottom).offset(16)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-106)
        }

        
    //
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.top.equalTo(googleButton.snp.bottom).offset(24)
//            make.bottom.equalTo(-20)
            make.centerX.equalTo(self.view)
        }
        
        let ppButton = UIButton()
        let str = NSMutableAttributedString(string: "Privacy Policy &")
        let strRange = NSRange.init(location: 0, length: str.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#4C4C4C")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: strRange)
        ppButton.setAttributedTitle(str, for: UIControl.State.normal)
        ppButton.contentHorizontalAlignment = .right
        ppButton.tag = 1001
        ppButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(ppButton)
        ppButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.left.equalTo(0)
        }
        
        let tou = UIButton()
        let toustr = NSMutableAttributedString(string: " Terms of Use")
        let toustrRange = NSRange.init(location: 0, length: toustr.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let tounumber = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        toustr.addAttributes([NSAttributedString.Key.underlineStyle: tounumber,
                              NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#4C4C4C")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: toustrRange)
        tou.setAttributedTitle(toustr, for: UIControl.State.normal)
        tou.contentHorizontalAlignment = .left
        tou.tag = 1002
        tou.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(tou)
        tou.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.right.equalTo(-2)
        }
    }
}

extension APpleLoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 请求完成，但是有错误
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 请求完成， 用户通过验证
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 拿到用户的验证信息，这里可以跟自己服务器所存储的信息进行校验，比如用户名是否存在等。
            //                let detailVC = DetailVC(cred: credential)
            //                self.present(detailVC, animated: true, completion: nil)
            
            print(credential)
            LoginManage.saveAppleUserIDAndUserName(userID: credential.user, userName: credential.email ?? "")
            self.dismiss(animated: true) {
            }
            loginCompletionBlock?()
        } else {
            
        }
    }
}

extension APpleLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }
}


 
