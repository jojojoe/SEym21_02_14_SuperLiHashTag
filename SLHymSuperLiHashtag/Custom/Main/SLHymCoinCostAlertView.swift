//
//  SLHymCoinCostAlertView.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/25.
//

import UIKit

class SLHymCoinCostAlertView: UIView {
    var actionType: String = "copy"
    
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let coinImgV = UIImageView(image: UIImage(named: "coins_buy_ic"))
        bottomBgView.addSubview(coinImgV)
        coinImgV.snp.makeConstraints {
            $0.bottom.equalTo(bottomBgView.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(45)
        }
        //
        let coinLabel = UILabel()
        coinLabel.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        coinLabel.textColor = UIColor(hexString: "#232323")
        coinLabel.textAlignment = .center
        coinLabel.numberOfLines = 0
        coinLabel.text = "It costs \(SLHymCoinManager.default.coinCostCount) coins to unlock paid items."
        bottomBgView.addSubview(coinLabel)
        coinLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(coinImgV.snp.bottom).offset(12)
            $0.width.equalTo(270)
            $0.height.greaterThanOrEqualTo(40)
        }
        //
        let okBtn = UIButton(type: .custom)
        bottomBgView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(coinLabel.snp.bottom).offset(32)
            $0.width.equalTo(120)
            $0.height.equalTo(36)
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn.setTitle("OK", for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        okBtn.setTitleColor(.black, for: .normal)
        okBtn.backgroundColor = UIColor(hexString: "#D0725C")
        okBtn.layer.cornerRadius = 8
        okBtn.layer.borderWidth = 2
        okBtn.layer.borderColor = UIColor.black.cgColor
    }
    
}

extension SLHymCoinCostAlertView {
    @objc func bgBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    
}
