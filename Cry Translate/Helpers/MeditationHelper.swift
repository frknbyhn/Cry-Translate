//
//  MeditationHelper.swift
//  PulseMonitor
//
//  Created by Furkan BEYHAN on 10.04.2023.
//

import Foundation

class SavedMeditationHelper {
    
    static func getList() -> [SavedMeditModel] {
        if let recentlyFavData = UserDefaults.standard.data(forKey: "SavedMeditModel") {
            let arrObj = try! PropertyListDecoder().decode([SavedMeditModel].self, from: recentlyFavData)
            return arrObj
        }
        return []
    }
    
    static func deleteItem(item: SavedMeditModel, completion: @escaping(Bool) -> (Void)) {
        if let recentlyFavData = UserDefaults.standard.data(forKey: "SavedMeditModel") {
            var arrObj = try! PropertyListDecoder().decode([SavedMeditModel].self, from: recentlyFavData)
            let contains = arrObj.map { $0.id == item.id }.contains(true)
            if contains {
                let indexSearch = arrObj.lastIndex { (foo) -> Bool in return item.id == foo.id }
                if let index = indexSearch {
                    arrObj.remove(at: index)
                    arrObj = arrObj.reversed()
                    let langArr = try! PropertyListEncoder().encode(arrObj)
                    UserDefaults.standard.set(langArr, forKey: "SavedMeditModel")
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    static func addList(item: SavedMeditModel) {
        if let recentlyFavData = UserDefaults.standard.data(forKey: "SavedMeditModel") {
            var arrObj = try! PropertyListDecoder().decode([SavedMeditModel].self, from: recentlyFavData)
            let contains = arrObj.map { $0.id == item.id }.contains(true)
            if !contains {
                arrObj.append(item)
                arrObj = arrObj.reversed()
                let langArr = try! PropertyListEncoder().encode(arrObj)
                UserDefaults.standard.set(langArr, forKey: "SavedMeditModel")
            }
        } else {
            let favData = try! PropertyListEncoder().encode([item])
            UserDefaults.standard.set(favData, forKey: "SavedMeditModel")
        }
    }
    
}

