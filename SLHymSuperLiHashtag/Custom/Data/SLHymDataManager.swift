//
//  SLHymDataManager.swift
//  SLHymSuperLiHashtag
//
//  Created by JOJO on 2021/5/21.
//

import UIKit
struct HashtagBundle: Codable {
    var bundleName: String = ""
    var tagList: [String] = []
    var iconImgName: String = ""
    
}
struct CaptionBundle: Codable {
    var bundleName: String = ""
    var captionList: [String] = []
    var iconImgName: String = ""
    
}


class SLHymDataManager: NSObject {
    static let `default` = SLHymDataManager()
    var _hashtagBundleList: [HashtagBundle]?
    var _captionBundleList: [CaptionBundle]?
    
    override init() {
        super.init()
        
    }
    func hashtagBundleList() -> [HashtagBundle] {
        if let hashtagBundles_m = _hashtagBundleList {
            return hashtagBundles_m
        } else {
            let bundles = SLHymDataManager.default.loadJson([HashtagBundle].self, name:"hashtagList") ?? []
            _hashtagBundleList = bundles
            return bundles
        }
    }
    func captionBundleList() -> [CaptionBundle] {
        if let captionBundles_m = _captionBundleList {
            return captionBundles_m
        } else {
            let bundles = SLHymDataManager.default.loadJson([CaptionBundle].self, name:"captionList") ?? []
            _captionBundleList = bundles
            return bundles
        }
    }
}


extension SLHymDataManager {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}
