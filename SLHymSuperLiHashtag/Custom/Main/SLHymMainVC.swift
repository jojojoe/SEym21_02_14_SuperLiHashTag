//
//  SLHymMainVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/21.
//

import UIKit

class SLHymMainVC: UIViewController {

    let settingView = SLHymSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSettingView()
    }
    
 
    

}

extension SLHymMainVC {
    func setupView() {
        let bgImgV = UIImageView(image: UIImage(named: "home_bg_pic"))
        view.addSubview(bgImgV)
        bgImgV.contentMode = .scaleAspectFill
        bgImgV.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        //
        let settingBtn = UIButton(type: .custom)
        view.addSubview(settingBtn)
        settingBtn.setImage(UIImage(named: "home_setting_ic"), for: .normal)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        let hashTagBtn = MVMainHomeBtn(frame: .zero, iconImg: UIImage(named: "home_pic_tag_bg")!, name: "Hashtag")
        view.addSubview(hashTagBtn)
        hashTagBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-80)
            $0.right.equalTo(view.snp.centerX).offset(-16)
            $0.width.equalTo(250/2)
            $0.height.equalTo(312/2)
        }
        hashTagBtn.addTarget(self, action: #selector(hashTagBtnClick(sender:)), for: .touchUpInside)
        //
        let customTagBtn = MVMainHomeBtn(frame: .zero, iconImg: UIImage(named: "custom_tag_bg_ic")!, name: "Custom tag")
        view.addSubview(customTagBtn)
        customTagBtn.snp.makeConstraints {
            $0.bottom.equalTo(hashTagBtn).offset(-28)
            $0.left.equalTo(view.snp.centerX).offset(16)
            $0.width.equalTo(250/2)
            $0.height.equalTo(312/2)
        }
        customTagBtn.addTarget(self, action: #selector(customTagBtnClick(sender:)), for: .touchUpInside)
        //
        let captionBtn = MVMainHomeBtn(frame: .zero, iconImg: UIImage(named: "caption_bg_ic")!, name: "Caption")
        view.addSubview(captionBtn)
        captionBtn.snp.makeConstraints {
            $0.top.equalTo(hashTagBtn.snp.bottom).offset(35)
            $0.left.equalTo(hashTagBtn)
            $0.width.equalTo(250/2)
            $0.height.equalTo(312/2)
        }
        captionBtn.addTarget(self, action: #selector(captionBtnClick(sender:)), for: .touchUpInside)
//
        let storeBtn = MVMainHomeBtn(frame: .zero, iconImg: UIImage(named: "store_coins_bg_ic")!, name: "Store")
        view.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(customTagBtn.snp.bottom).offset(35)
            $0.left.equalTo(customTagBtn)
            $0.width.equalTo(250/2)
            $0.height.equalTo(312/2)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
    }
    
    func addSettingView() {
        settingView.alpha = 0
        settingView.upVC = self
        view.addSubview(settingView)
        settingView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        settingView.showLoginViewBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.showLoginVC()
        }
        settingView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.settingView.alpha = 0
            }
            
        }
        
        
    }
    
    
}

extension SLHymMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            self.settingView.alpha = 1
        }
    }
    @objc func hashTagBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(SLHymHashBundleVC())
    }
    @objc func customTagBtnClick(sender: UIButton) {
        let customVC = SLHymCustomTagEditVC(titleName: "Custom tag", contentStr: "")
        self.navigationController?.pushViewController(customVC)
        
    }
    @objc func captionBtnClick(sender: UIButton) {
        if let captionBundle = SLHymDataManager.default.captionBundleList().first {
            let captionVC = SLHymCaptionListVC(captionBundle: captionBundle)
            self.navigationController?.pushViewController(captionVC)
        }
        
    }
    @objc func storeBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(SLHymStoreVC())
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            let loginVC = LoginManage.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
}


class MVMainHomeBtn: UIButton {
    var iconImage: UIImage
    var nameStr: String
    
    //            250 × 312
    init(frame: CGRect, iconImg: UIImage, name: String) {
        self.iconImage = iconImg
        self.nameStr = name
        super.init(frame: frame)
        setupView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        let bgImgV = UIImageView(image: iconImage)
        addSubview(bgImgV)
        bgImgV.contentMode = .scaleAspectFit
        bgImgV.snp.makeConstraints {

            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        nameLabel.textColor = UIColor(hexString: "#68523E")
        nameLabel.text = nameStr
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(-14)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
    }
    
    
}
