//
//  SLHymExtensionToll.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/24.
//

import Foundation
import Foundation
import Alertift
import ZKProgressHUD

public extension UIApplication {
    @discardableResult
    func openURL(url: URL) -> Bool {
        guard UIApplication.shared.canOpenURL(url) else { return false }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }

    @discardableResult
    func openURL(url: String?) -> Bool {
        guard let str = url, let url = URL(string: str) else { return false }
        return openURL(url: url)
    }
}


extension UIApplication {
//    public static var rootController: UIViewController? {
//        if #available(iOS 13.0, *) {
//            return shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
//        } else {
//            return shared.keyWindow?.rootViewController
//        }
//
//    }
}

public struct HUD {
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }

    public static func hide() {
        ZKProgressHUD.dismiss()
    }

    
    public static func error(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showError(value, autoDismissDelay: 2.0)
    }

    public static func success(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showSuccess(value, autoDismissDelay: 2.0)
    }
    
    public static func progress(_ value: CGFloat?) {
        ZKProgressHUD.showProgress(value)
    }
    
    public static func progress(_ value: CGFloat?, status: String? = nil) {
        
        ZKProgressHUD.showProgress(value, status: status, onlyOnceFont: UIFont(name: "Avenir-Black", size: 14))
    }
}

//public struct Alert {
//    public static func error(_ value: String?, title: String? = "Error", success: (() -> Void)? = nil) {
//
//        HUD.hide()
//        Alertift
//            .alert(title: title, message: value)
//            .action(.cancel("OK"), handler: { _, _, _ in
//                success?()
//            })
//            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
//    }
//
//    public static func message(_ value: String?, success: (() -> Void)? = nil) {
//
//        HUD.hide()
//        Alertift
//            .alert(message: value)
//            .action(.cancel("OK"), handler: { _, _, _ in
//                success?()
//            })
//            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
//    }
//}

//public extension UIViewController {
//    var rootVC: UIViewController? {
//        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
//    }
//
//    var visibleVC: UIViewController? {
//        return topMost(of: rootVC)
//    }
//
//    var visibleTabBarController: UITabBarController? {
//        return topMost(of: rootVC)?.tabBarController
//    }
//
//    var visibleNavigationController: UINavigationController? {
//        return topMost(of: rootVC)?.navigationController
//    }
//
//    private func topMost(of viewController: UIViewController?) -> UIViewController? {
//        if let presentedViewController = viewController?.presentedViewController {
//            return topMost(of: presentedViewController)
//        }
//
//        // UITabBarController
//        if let tabBarController = viewController as? UITabBarController,
//            let selectedViewController = tabBarController.selectedViewController {
//            return topMost(of: selectedViewController)
//        }
//
//        // UINavigationController
//        if let navigationController = viewController as? UINavigationController,
//            let visibleViewController = navigationController.visibleViewController {
//            return topMost(of: visibleViewController)
//        }
//
//        return viewController
//    }
//
//    func present(_ controller: UIViewController) {
//        self.modalPresentationStyle = .fullScreen
//
//        present(controller, animated: true, completion: nil)
//    }
//
//    func pushVC(_ controller: UIViewController ,animate: Bool) {
//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(controller, animated: animate)
//        } else {
//            present(controller, animated: animate, completion: nil)
//        }
//    }
//
//    func popVC() {
//        if let navigationController = self.navigationController {
//            navigationController.popViewController()
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    func presentDissolve(_ controller: UIViewController, completion: (() -> Void)? = nil) {
//        controller.modalPresentationStyle = .overFullScreen
//        controller.modalTransitionStyle = .crossDissolve
//        present(controller, animated: true, completion: completion)
//    }
//
//    func presentFullScreen(_ controller: UIViewController, completion: (() -> Void)? = nil) {
//        controller.modalPresentationStyle = .fullScreen
//        controller.modalTransitionStyle = .crossDissolve
//        present(controller, animated: true, completion: completion)
//    }
//}


@objc
public class HUDClass: NSObject {
    @objc
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }

    @objc
    public static func hide() {
        ZKProgressHUD.dismiss()
    }
}

extension UITextView {
    
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil { // 不存在是 创建 绑定
                if (self.font == nil) { // 防止没大小时显示异常 系统默认设置14
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = UIFont.systemFont(ofSize: 14)//self.font
                label?.textColor = UIColor.lightGray
                label?.textAlignment = self.textAlignment
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            } else {
                label?.font = self.font
                label?.textColor = label?.textColor.withAlphaComponent(0.6)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
