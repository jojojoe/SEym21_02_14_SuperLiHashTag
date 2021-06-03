//
//  SLHymStoreVC.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/24.
//

import UIKit
import SwifterSwift
import NoticeObserveKit

class SLHymStoreVC: UIViewController {
    var collection: UICollectionView!
    private var pool = Notice.ObserverPool()
    let topNameLabel = UILabel()
    let coinLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#F8EEE6")
        setupView()
        addNotificationObserver()
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupView() {
        //
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
        topNameLabel.text = "Store"
        view.addSubview(topNameLabel)
        topNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        coinLabel.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        coinLabel.textColor = UIColor(hexString: "#000000")
        view.addSubview(coinLabel)
        coinLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backBtn)
            $0.height.greaterThanOrEqualTo(1)
            $0.width.greaterThanOrEqualTo(1)
        }
        updateTopLabel()
        //
        let topIconImgV = UIImageView(image: UIImage(named: "coins_buy_ic"))
        topIconImgV.contentMode = .scaleAspectFit
        view.addSubview(topIconImgV)
        topIconImgV.snp.makeConstraints {
            $0.centerY.equalTo(coinLabel)
            $0.right.equalTo(coinLabel.snp.left).offset(-8)
            $0.width.equalTo(24)
            $0.height.equalTo(17)
        }
        
        //
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
            $0.top.equalTo(backBtn.snp.bottom).offset(18)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: SLHymStoreCell.self)
    }
    
    func selectCoinItem(item: StoreItem) {
        SLHymCoinManager.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                SLHymCoinManager.default.addCoin(coin: item.coin)
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateTopLabel()
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }
    func updateTopLabel() {
        self.coinLabel.text = "\(SLHymCoinManager.default.coinCount)"
    }
}

extension SLHymStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: SLHymStoreCell.self, for: indexPath)
        
        let item = SLHymCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin) coins"
        cell.priceLabel.text = item.price
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SLHymCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLHymStoreVC: UICollectionViewDelegateFlowLayout {
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

extension SLHymStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = SLHymCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class SLHymStoreCell: UICollectionViewCell {
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(bgImageV)
        bgImageV.image = UIImage(named: "store_coins_buy_bg")
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        coverImageV.image = UIImage(named: "coins_buy_ic")
        coverImageV.contentMode = .scaleAspectFit
        contentView.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(35)
            $0.width.equalTo(45)
            $0.height.equalTo(31)
        }
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor(hexString: "#000000")
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(1)
            $0.top.equalTo(coverImageV.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        priceLabel.backgroundColor = .clear
        priceLabel.textColor = UIColor(hexString: "#68523E")
        priceLabel.font = UIFont(name: "Avenir-BlackOblique", size: 18)
        priceLabel.textAlignment = .center
        contentView.addSubview(priceLabel)
        priceLabel.layer.cornerRadius = 0
        priceLabel.layer.masksToBounds = true
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.layer.borderWidth = 0
        priceLabel.layer.borderColor = UIColor.black.cgColor
        priceLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
    
    
}
