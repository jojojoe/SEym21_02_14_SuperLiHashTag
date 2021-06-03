//
//  SLHymTagListVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/25.
//

import UIKit

class SLHymTagListVC: UIViewController {
    let coinAlertView = SLHymCoinCostAlertView()
    var tagBundle: HashtagBundle
    var isPro: Bool
    var currentCopyTagStr: String?
    
    init(tagBundle: HashtagBundle, isPro: Bool) {
        self.tagBundle = tagBundle
        self.isPro = isPro
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
        topNameLabel.text = tagBundle.bundleName
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
        collection.register(cellWithClass: SLHymTagListCell.self)
    }
    
 

}

extension SLHymTagListVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
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
                        self.showEditVC(titleName: "Custom tag", contentString: tagStr)
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

extension SLHymTagListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withClass: SLHymTagListCell.self, for: indexPath)
        let tag = tagBundle.tagList[indexPath.item]
        cell.contentTextLabel.text = tag
        if isPro {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        cell.tagCopyBtnClickBlock = {
            [weak self] tagStr, tagIsPro in
            guard let `self` = self else {return}
            if tagIsPro {
                self.coinAlertView.actionType = "copy"
                self.currentCopyTagStr = tagStr
                UIView.animate(withDuration: 0.25) {
                    self.coinAlertView.alpha = 1
                }
            } else {
                self.showCopyAction(contentString: tagStr)
                
            }
        }
        cell.tagEditBtnClickBlock = {
            [weak self] tagStr, tagIsPro in
            guard let `self` = self else {return}
            
            if tagIsPro {
                self.coinAlertView.actionType = "edit"
                self.currentCopyTagStr = tagStr
                UIView.animate(withDuration: 0.25) {
                    self.coinAlertView.alpha = 1
                }
            } else {
                self.showEditVC(titleName: "Custom tag", contentString: tagStr)
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagBundle.tagList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLHymTagListVC: UICollectionViewDelegateFlowLayout {
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

extension SLHymTagListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


 
class SLHymTagListCell: UICollectionViewCell {
    
    let contentImgV = UIImageView()
    let contentTextLabel = UILabel()
    let proImgV = UIImageView(image: UIImage(named: "pro_ic"))
    let tagCopyBtn = UIButton(type: .custom)
    let tagEditBtn = UIButton(type: .custom)
    var tagCopyBtnClickBlock: ((String, Bool)->Void)?
    var tagEditBtnClickBlock: ((String, Bool)->Void)?
    
    
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
        contentTextLabel.font = UIFont(name: "Avenir-Heavy", size: 12)
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
        contentView.addSubview(tagCopyBtn)
        tagCopyBtn.snp.makeConstraints {
            $0.bottom.equalTo(-25)
            $0.right.equalTo(-20)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        tagCopyBtn.addTarget(self, action: #selector(tagCopyBtnClick(sender:)), for: .touchUpInside)
        tagCopyBtn.setTitle("Copy", for: .normal)
        tagCopyBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        tagCopyBtn.setTitleColor(.black, for: .normal)
        tagCopyBtn.backgroundColor = UIColor(hexString: "#D0725C")
        tagCopyBtn.layer.cornerRadius = 8
        tagCopyBtn.layer.borderWidth = 2
        tagCopyBtn.layer.borderColor = UIColor.black.cgColor
        //
        contentView.addSubview(tagEditBtn)
        tagEditBtn.snp.makeConstraints {
            $0.bottom.equalTo(-25)
            $0.right.equalTo(tagCopyBtn.snp.left).offset(-12)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        tagEditBtn.addTarget(self, action: #selector(tagEditBtnClick(sender:)), for: .touchUpInside)
        tagEditBtn.setTitle("Edit", for: .normal)
        tagEditBtn.titleLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        tagEditBtn.setTitleColor(.black, for: .normal)
        tagEditBtn.backgroundColor = UIColor(hexString: "#D0725C")
        tagEditBtn.layer.cornerRadius = 8
        tagEditBtn.layer.borderWidth = 2
        tagEditBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func tagCopyBtnClick(sender: UIButton) {
        var isPro = true
        if proImgV.isHidden {
            isPro = false
        }
        tagCopyBtnClickBlock?(contentTextLabel.text ?? "", isPro)
    }
    @objc func tagEditBtnClick(sender: UIButton) {
        var isPro = true
        if proImgV.isHidden {
            isPro = false
        }
        tagEditBtnClickBlock?(contentTextLabel.text ?? "", isPro)
    }
    
}


