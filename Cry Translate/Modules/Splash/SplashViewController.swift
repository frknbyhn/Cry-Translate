//
//  SplashViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit
import DTTJailbreakDetection
import FirebaseRemoteConfig
import Firebase

protocol PremiumClosedProtocol: AnyObject {
    func premiumClosed()
}

class SplashViewController: BaseVC, StoryboardLoadable, PremiumClosedProtocol {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var remoteConfig: RemoteConfig!
    var frun: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        activityIndicator.startAnimating()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if DTTJailbreakDetection.isJailbroken() {
                let alert : UIAlertController = UIAlertController(title: "Error", message: "This app is only supported on unmodified versions of iOS", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.fetchConfig()
            }
        }
    }
    
    func fetchConfig() {
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activate { status, error in
                    self.frun = self.remoteConfig["frun"].boolValue
                    UserDefaults.standard.set(self.remoteConfig["star"].boolValue, forKey: "Star")
                    self.routeAppFate()
                }
            } else {
                self.frun = false
                UserDefaults.standard.set(true, forKey: "Star")
                self.routeAppFate()
            }
        }
    }
    
    func routeAppFate() {
        if self.frun {
            DispatchQueue.main.async {
                let nc = BaseNav(rootViewController: PremiumViewController.instantiate(delegate: self))
                nc.modalPresentationStyle = .fullScreen
                nc.modalTransitionStyle = .coverVertical
                self.present(nc, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                StarterHelper.checkInitial()
            }
        }
    }
    
    func premiumClosed() {
        DispatchQueue.main.async {
            StarterHelper.checkInitial()
        }
    }

}
