//
//  NoHandlerPopupViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit

class NoHandlerPopupViewController: BaseVC {

    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainCenter: NSLayoutConstraint!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var okayView: UIView!
    @IBOutlet weak var okayLabel: UILabel!
    
    var comingMain = ""
    var comingDesc = ""
    
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
        mainLabel.text = localized(comingMain)
        descLabel.text = localized(comingDesc)
        okayLabel.text = localized("Okay")
        okayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
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
    
    @objc func closeAction() {
        self.hideView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true)
        }
    }

}

extension NoHandlerPopupViewController {
    static func instantiate(main: String, desc: String) -> NoHandlerPopupViewController {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NoHandlerPopupViewController") as? NoHandlerPopupViewController else {
            fatalError("NoHandlerPopupViewController not found")
        }
        vc.comingMain = main
        vc.comingDesc = desc
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
