//
//  BaseNav.swift
//  LogicQR
//
//  Created by Furkan BEYHAN on 1.09.2022.
//

import UIKit

class BaseNav: UINavigationController, UIGestureRecognizerDelegate, StoryboardLoadable {

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        if let lastVC = self.viewControllers.last
        {
            return lastVC.preferredStatusBarStyle
        }
        return .default
    }
    
    override public var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        /// -> Setup Navigation Bar
        view.backgroundColor = navigationBar.barTintColor
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage =  UIImage()
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .white
    }
    
}

extension UINavigationController{
    
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}

