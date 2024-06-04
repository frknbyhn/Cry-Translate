//
//  SceneDelegate.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = self.window
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        var viewControllerName = String()
        viewControllerName = "SplashViewController"
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        tryToPresentAd()
    }
    
}

extension SceneDelegate: GADFullScreenContentDelegate {
    func requestAppOpenAd() {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: AdKeys.scene,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
            self.appOpenAd = appOpenAdIn
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            print("Ad is ready")
        })
    }
    
    func tryToPresentAd() {
        if let gOpenAd = self.appOpenAd, let rwc = self.window?.rootViewController, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            gOpenAd.present(fromRootViewController: rwc)
        } else {
            self.requestAppOpenAd()
        }
    }
    
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
}
