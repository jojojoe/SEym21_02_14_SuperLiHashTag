//
//  SLHymCaptionListVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/25.
//

import UIKit

class SLHymCaptionListVC: UIViewController {
    let coinAlertView = SLHymCoinCostAlertView()
    var captionBundle: CaptionBundle
    var currentCopyTagStr: String?
    init(captionBundle: CaptionBundle) {
        self.captionBundle = captionBundle
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#F8EEE6")
        setupView()
        setupCoinAlertView()
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
        let topNameLabel = UILabel()
        topNameLabel.font = UIFont(name: "Avenir-BlackOblique", size: 16)
        topNameLabel.textColor = UIColor(hexString: "#68523E")
        topNameLabel.text = captionBundle.bundleName
        view.addSubview(topNameLabel)
        topNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        var collection: UICollectionView!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: SLHymCaptionListCell.self)
    }
}



extension SLHymCaptionListVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SLHymCaptionListVC {
    
    func setupCoinAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            if let tagStr = self.currentCopyTagStr {
                
                if SLHymCoinManager.default.coinCount >= SLHymCoinManager.default.coinCostCount {
                    if self.coinAlertView.actionType == "edit" {
                        self.showEditVC(titleName: "Custom Caption", contentString: tagStr)
                    } else {
                        self.showCopyAction(contentString: tagStr)
                    }
                    SLHymCoinManager.default.costCoin(coin: SLHymCoinManager.default.coinCostCount)
                    self.currentCopyTagStr = nil
                } else {
                    self.showAlert(title: "", message: "Coins shortage. please buy coins first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(SLHymStoreVC())
                        }
                    }
                }
                
                
            }
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.currentCopyTagStr = nil
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
    }
    //
    func showEditVC(titleName: String, contentString: String) {
        let customVC = SLHymCustomTagEditVC(titleName: titleName, contentStr: contentString)
        self.navigationController?.pushViewController(customVC)
    }
    
    func showCopyAction(contentString: String) {
        UIPasteboard.general.string = contentString
        HUD.success("Copy Successfully")
    }
    
}

extension SLHymCaptionListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withClass: SLHymCaptionListCell.self, for: indexPath)
        
        let tag = captionBundle.captionList[indexPath.item]
        cell.contentTextLabel.text = tag
        if indexPath.item >= 2 {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        cell.copyBtnClickBlock = {
            [weak self] captionStr, captionIsPro in
            guard let `self` = self else {return}
            if captionIsPro {
                self.coinAlertView.actionType = "edit"
                self.currentCopyTagStr = captionStr
                UIView.animate(withDuration: 0.25) {
                    self.coinAlertView.alpha = 1
                }
            } else {
                self.showCopyAction(contentString: captionStr)
                
            }
        }
        cell.editBtnClickBlock = {
            [weak self] captionStr, captionIsPro in
            guard let `self` = self else {return}
            if captionIsPro {
                self.coinAlertView.actionType = "edit"
                self.currentCopyTagStr = captionStr
                UIView.animate(withDuration: 0.25) {
                    self.coinAlertView.alpha = 1
                }
            } else {
                self.showEditVC(titleName: "Custom Caption", contentString: captionStr)
                
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return captionBundle.captionList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLHymCaptionListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 652/2, height: 492/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension SLHymCaptionListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


 
class SLHymCaptionListCell: UICollectionViewCell {
    
    let contentImgV = UIImageView()
    let contentTextLabel = UILabel()
    let proImgV = UIImageView(image: UIImage(named: "pro_ic"))
    let captionCopyBtn = UIButton(type: .custom)
    let captionEditBtn = UIButton(type: .custom)
    var copyBtnClickBlock: ((String, Bool)->Void)?
    var editBtnClickBlock: ((String, Bool)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.image = UIImage(named: "tag_copy_bg_ic")
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        contentTextLabel.numberOfLines = 0
        contentTextLabel.textAlignment = .left
        contentTextLabel.adjustsFontSizeToFitWidth = true
        contentTextLabel.textColor = UIColor(hexString: "#68523E")
        contentTextLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        contentView.addSubview(contentTextLabel)
        contentTextLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(34)
            $0.bottom.equalTo(-60)
            $0.top.equalTo(44)
        }
        //
        
        proImgV.contentMode = .scaleAspectFit
        contentView.addSubview(proImgV)
        proImgV.snp.makeConstraints {
            $0.top.equalTo(contentImgV).offset(14)
            $0.left.equalTo(contentImgV).offset(14)
            $0.width.height.equalTo(46/2)
        }
        //
        contentView.addSubview(captionCopyBtn)
        captionCopyBtn.snp.makeConstraints {
            $0.bottom.equalTo(-25)
            $0.right.equalTo(-20)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        captionCopyBtn.addTarget(self, action: #selector(captionCopyBtnClick(sender:)), for: .touchUpInside)
        captionCopyBtn.setTitle("Copy", for: .normal)
        captionCopyBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        captionCopyBtn.setTitleColor(.black, for: .normal)
        captionCopyBtn.backgroundColor = UIColor(hexString: "#7181FF")
        captionCopyBtn.layer.cornerRadius = 8
        captionCopyBtn.layer.borderWidth = 2
        captionCopyBtn.layer.borderColor = UIColor.black.cgColor
        //
        contentView.addSubview(captionEditBtn)
        captionEditBtn.snp.makeConstraints {
            $0.bottom.equalTo(-25)
            $0.right.equalTo(captionCopyBtn.snp.left).offset(-12)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        captionEditBtn.addTarget(self, action: #selector(captionEditBtnClick(sender:)), for: .touchUpInside)
        captionEditBtn.setTitle("Edit", for: .normal)
        captionEditBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        captionEditBtn.setTitleColor(.black, for: .normal)
        captionEditBtn.backgroundColor = UIColor(hexString: "#7181FF")
        captionEditBtn.layer.cornerRadius = 8
        captionEditBtn.layer.borderWidth = 2
        captionEditBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func captionCopyBtnClick(sender: UIButton) {
        var isPro = true
        if proImgV.isHidden {
            isPro = false
        }
        copyBtnClickBlock?(contentTextLabel.text ?? "", isPro)
    }
    @objc func captionEditBtnClick(sender: UIButton) {
        var isPro = true
        if proImgV.isHidden {
            isPro = false
        }
        editBtnClickBlock?(contentTextLabel.text ?? "", isPro)
    }
    
}
