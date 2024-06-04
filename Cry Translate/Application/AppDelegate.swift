//
//  AppDelegate.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit
import Firebase
import FirebaseAnalytics
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var UDID = String()
    let keychain = KeychainSwift()
    var restrictRotation: UIInterfaceOrientationMask = .portrait
    let center  = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationSetup()
        
        checkPremiumServices()
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        SwiftyStoreKit.completeTransactions { _ in }
        
        return true
    }

    private func getUDID() {
        if keychain.get("UDID") == nil {
            UDID = UIDevice.current.identifierForVendor!.uuidString
            UDID = UDID.replacingOccurrences(of: "-", with: "")
            keychain.set(UDID, forKey: "UDID")
            Config.UDID = UDID
            UserDefaults.standard.set(UDID, forKey: "UDID")
        } else {
            UDID = String(format: "%@", keychain.get("UDID")!)
            Config.UDID = UDID
            UserDefaults.standard.set(UDID, forKey: "UDID")
        }
    }
    
    func applicationSetup() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        getUDID()
    }
    
    func checkPremiumServices() {
        if UserDefaults.standard.bool(forKey: "Premium") {
            PremiumServices.checkPremium(premiumID: Config.weeklyID) { (lifetimeStatus) in
                if lifetimeStatus {
                    UserDefaults.standard.set(true, forKey: "Premium")
                } else {
                    PremiumServices.checkPremium(premiumID: Config.monthlyID) { (monthlyStatus) in
                        if monthlyStatus {
                            UserDefaults.standard.set(true, forKey: "Premium")
                        } else {
                            UserDefaults.standard.set(false, forKey: "Premium")
                        }
                    }
                }
            }
        }
    }

}

enum Config {
    static var UDID: String = ""
    static var appUrl: String = "https://apps.apple.com/us/app/cry-translate/id6461457023"
    static var premium = UserDefaults.standard.bool(forKey: "Premium")
    static var secretKey = "4ab048137e894322901b1ff7d65aca0d"
    static var weeklyID: String = "com.crytranslate.weekly"
    static var monthlyID: String = "com.crytranslate.monthly"
    static var yearlyID: String = "com.crytranslate.yearly"
    static var privacyLink = "https://www.freeprivacypolicy.com/live/933dd627-f059-4640-be1d-802815efe01f"
    static var termsLink = "https://www.freeprivacypolicy.com/live/9b1c48f7-67ba-4dc6-9afd-86a840d906fc"
}

struct AdKeys {
    static var rewarded: String = "ca-app-pub-5799989618079326/2995111923"
    static var scene: String = "ca-app-pub-5799989618079326/5675431373"
}
