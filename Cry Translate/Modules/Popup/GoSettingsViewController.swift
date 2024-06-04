//
//  GoSettingsViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 26.08.2023.
//

import UIKit

class GoSettingsViewController: BaseVC {

    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainCenter: NSLayoutConstraint!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var okayView: UIView!
    @IBOutlet weak var okayLabel: UILabel!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adLabel: UILabel!
    
    var goSettingsProtocol: GoSettingsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainCenter.constant = (UIScreen.main.bounds.height / 2 + self.mainView.bounds.height)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showView()
    }
    
    func setupUI() {
        effectView.blurSetup()
        mainView.roundCorners(radius: 8)
        okayView.roundCorners(radius: 8)
        adView.roundCorners(radius: 8)
        mainLabel.text = localized("Need Permission")
        descLabel.text = localized("You need to give microphone permission to use the app.")
        okayLabel.text = localized("Cancel")
        adLabel.text = localized("Go Settings")
        okayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(preAction)))
        adView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(adAction)))
        effectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
    }
    
    @objc func showView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.mainCenter.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func hideView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.mainCenter.constant = (UIScreen.main.bounds.height / 2 + self.mainView.bounds.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func preAction() {
        self.hideView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true)
        }
    }
    
    @objc func adAction() {
        self.hideView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true) {
                self.goSettingsProtocol?.goSettings()
            }
        }
    }
    
    @objc func closeAction() {
        self.hideView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true)
        }
    }

}

extension GoSettingsViewController {
    static func instantiate() -> GoSettingsViewController {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "GoSettingsViewController") as? GoSettingsViewController else {
            fatalError("GoSettingsViewController not found")
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
