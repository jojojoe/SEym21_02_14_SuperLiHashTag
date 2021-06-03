//
//  LoginPingGouManager.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/21.
//

import UIKit
import FirebaseUI
import Firebase
import CryptoKit
import AuthenticationServices



import UIKit

class ApploginUserInfoModel: NSObject {
    
    var userName: String? = ""
    var isAppleLogin = false

}

let keychainAppleUserID = "AppleUserID_Smarttags"
let keychainAppleUserName = "AppleUserName_Smarttags"
let keyChainKey = "appLogInasdlfkjas;ljfl;asdjf;ald_Smarttags"

class LoginManage: NSObject, FUIAuthDelegate {
    
    let authUI = FUIAuth.defaultAuthUI()
    fileprivate var currentNonce: String?
    var loginCompletionBlock: (()->Void)?
    
    
    class func receivesAuthenticationProcess(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
          if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
          }
          // other URL handling goes here.
          return false
    }
    
    class func fireAppInit() {
        FirebaseApp.configure()
        
        
    }
    
    static let shared = LoginManage()
    private override init() {
        super.init()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth.init(authUI: authUI!),
        ]
        authUI?.providers = providers
    }
    
    class func saveAppleUserIDAndUserName(userID: String, userName: String) {
        UserDefaults.standard.setValue(userID, forKey: keychainAppleUserID)
        UserDefaults.standard.setValue(userName, forKey: keychainAppleUserName)
        

    }
    
    class func obtainAppleUserID() -> String {
        let userID = UserDefaults.standard.string(forKey: keychainAppleUserID)
        return userID ?? ""
        
//        let keychainManager = Keychain(service: keyChainKey)
//        let userID = keychainManager[keychainAppleUserID]
//        return userID ?? ""
    }
    
    class func obtainAppleUserName() -> String {
        if let userName = UserDefaults.standard.string(forKey: keychainAppleUserName), userName.count > 0 {
            return userName
        } else {
            return "User"
        }
        
//        let keychainManager = Keychain(service: keyChainKey)
//        if let userName = keychainManager[keychainAppleUserName], userName.count > 0 {
//            return userName
//        } else {
//            return obtainAppleUserID()
//        }
    }
    
    class func currentLoginUser() -> ApploginUserInfoModel? {
        
        if let currentUser = Auth.auth().currentUser {
            let userModel = ApploginUserInfoModel()
            userModel.isAppleLogin = false
            if let userName = currentUser.providerData[0].displayName {
                userModel.userName = userName
            } else {
                userModel.userName = currentUser.providerData[0].email
            }
            return userModel
        }
        
        if self.obtainAppleUserID().count > 0 {
            let userModel = ApploginUserInfoModel()
            userModel.isAppleLogin = true
            userModel.userName = self.obtainAppleUserName()
            return userModel
        }
        return nil
    }
    
    
    func googleUserLogout() {
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }
    }
    
    func appleUserLogout() {
        UserDefaults.standard.setValue(nil, forKey: keychainAppleUserID)
        UserDefaults.standard.setValue(nil, forKey: keychainAppleUserName)
        
//        let keychainManager = Keychain(service: keyChainKey)
//        do {
//            try keychainManager.set("", key: keychainAppleUserID)
//            try keychainManager.set("", key: keychainAppleUserName)
//        } catch let error {
//            print(error)
//        }
    }
    
    func logout() {
        if let userMode = LoginManage.currentLoginUser() {
            if userMode.isAppleLogin == true {
                appleUserLogout()
            } else {
                googleUserLogout()
            }
        } else {
            HUD.error("Please login first")
        }
    }
    
    func obtainVC() -> FUIAuthPickerViewController {
        let loginVC = APpleLoginVC.init(authUI: self.authUI!)
        loginVC.loginCompletionBlock = self.loginCompletionBlock
        return loginVC
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        var a = authDataResult?.additionalUserInfo?.profile?["name"]
        loginCompletionBlock?()
    }
    
}

extension DispatchQueue {
    private static var _onceToken = [String]()
    
    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        
        defer
        {
            objc_sync_exit(self)
        }

        if _onceToken.contains(token)
        {
            return
        }

        _onceToken.append(token)
        block()
    }
}
