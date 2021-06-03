//
//  SLHymHashBundleVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/24.
//

import UIKit

class SLHymHashBundleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didSelect(hashBundle: HashtagBundle, isPro: Bool) {
        let tagListVC = SLHymTagListVC(tagBundle: hashBundle, isPro: isPro)
        self.navigationController?.pushViewController(tagListVC)
    }
}

extension SLHymHashBundleVC {
    func setupView() {
        view.backgroundColor = UIColor(hexString: "#F8EEE6")
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
        topNameLabel.text = "Hashtag"
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
        collection.register(cellWithClass: SLHymHashBundleCell.self)
        
    }
}

extension SLHymHashBundleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SLHymHashBundleCell.self, for: indexPath)
        if let bundle =  SLHymDataManager.default.hashtagBundleList()[safe: indexPath.item] {
            cell.nameLabel.text = bundle.bundleName
            cell.contentImgV.image = UIImage(named: bundle.iconImgName)
            if indexPath.item <= 1 {
                cell.proImgV.isHidden = true
            } else {
                cell.proImgV.isHidden = false
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SLHymDataManager.default.hashtagBundleList().count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLHymHashBundleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        return CGSize(width: 250/2, height: 312/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = (UIScreen.main.bounds.width - (250/2) * 2 - 24) / 2
        return UIEdgeInsets(top: 0, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension SLHymHashBundleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = SLHymDataManager.default.hashtagBundleList()[indexPath.item]
        var isPro = true
        if indexPath.item <= 1 {
            isPro = false
        }
        didSelect(hashBundle: bundle, isPro: isPro)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class SLHymHashBundleCell: UICollectionViewCell {
    
    var bgImgV = UIImageView(image: UIImage(named: "store_coins_buy_bg"))
    let contentImgV = UIImageView()
    let nameLabel = UILabel()
    let proImgV = UIImageView(image: UIImage(named: "pro_ic"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        bgImgV.contentMode = .scaleAspectFit
        //
        contentImgV.contentMode = .scaleAspectFill
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(14)
            $0.width.height.equalTo(97)
        }
        //
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "Avenir-BlackOblique", size: 18)
        nameLabel.textColor = UIColor(hexString: "#68523E")
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-14)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        proImgV.contentMode = .scaleAspectFit
        contentView.addSubview(proImgV)
        proImgV.snp.makeConstraints {
            $0.top.equalTo(contentImgV).offset(4)
            $0.right.equalTo(contentImgV).offset(-4)
            $0.width.height.equalTo(46/2)
        }
    }
    
    
    
}

