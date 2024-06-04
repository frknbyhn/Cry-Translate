//
//  LoaderViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit

class LoaderViewController: BaseVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var animView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        effectView.blurSetup()
        mainView.roundCorners(radius: 10)
        setAnimation(view: animView, name: "loader", loop: true)
    }
}

extension LoaderViewController {
    static func instantiate() -> LoaderViewController {
        let storyboard = UIStoryboard(name: "Loader", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LoaderViewController") as? LoaderViewController else {
            fatalError("LoaderViewController not found")
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
