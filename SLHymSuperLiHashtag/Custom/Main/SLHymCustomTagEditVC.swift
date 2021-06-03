//
//  SLHymCustomTagEditVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/25.
//

import UIKit

class SLHymCustomTagEditVC: UIViewController {
    let topNameLabel = UILabel()
    let contentCopyBtn = UIButton(type: .custom)
    let contentTextView = UITextView()
    var topTitleName: String
    var contentStr: String
    init(titleName: String, contentStr: String) {
        self.topTitleName = titleName
        self.contentStr = contentStr
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentTextView.becomeFirstResponder()
        
    }
    
    func setupView() {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_ic"), for: .normal)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            $0.width.height.equalTo(44)
        }
        //
        topNameLabel.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        topNameLabel.textColor = UIColor(hexString: "#68523E")
        topNameLabel.text = topTitleName
        view.addSubview(topNameLabel)
        topNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        let contentBgView = UIView()
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(652/2)
            $0.height.equalTo(492/2)
        }
        let contentBgImgV = UIImageView(image: UIImage(named: "tag_copy_bg_ic"))
        contentBgImgV.contentMode = .scaleAspectFit
        contentBgView.addSubview(contentBgImgV)
        contentBgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        contentTextView.backgroundColor = .clear
        contentTextView.font = UIFont(name: "Avenir-Heavy", size: 12)
        contentTextView.textColor = UIColor(hexString: "#AB9F94")
        contentTextView.textAlignment = .left
        contentTextView.placeholder = "You can customize your own tag…"
        contentTextView.text = contentStr
        contentBgView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(45)
            $0.bottom.equalTo(-60)
            $0.centerX.equalToSuperview()
        }
        //
        contentBgView.addSubview(contentCopyBtn)
        contentCopyBtn.snp.makeConstraints {
            $0.bottom.equalTo(-25)
            $0.right.equalTo(-20)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        contentCopyBtn.addTarget(self, action: #selector(contentCopyBtnClick(sender:)), for: .touchUpInside)
        contentCopyBtn.setTitle("Copy", for: .normal)
        contentCopyBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        contentCopyBtn.setTitleColor(.black, for: .normal)
        contentCopyBtn.backgroundColor = UIColor(hexString: "#7181FF")
        contentCopyBtn.layer.cornerRadius = 8
        contentCopyBtn.layer.borderWidth = 2
        contentCopyBtn.layer.borderColor = UIColor.black.cgColor
    }
    
}

extension SLHymCustomTagEditVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        contentTextView.resignFirstResponder()
    }
    
    @objc func contentCopyBtnClick(sender: UIButton) {
        UIPasteboard.general.string = contentTextView.text
        HUD.success("Copy Successfully")
    }
}
