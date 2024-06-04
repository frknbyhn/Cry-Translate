
import Foundation
import UIKit

extension UIViewController {
    
    static var id:String {
        return String(describing: self)
    }
    
    @objc func showLoader() {
        DispatchQueue.main.async {
            self.present(LoaderViewController.instantiate(), animated: true, completion: nil)
        }
    }
    
    @objc func hideLoader() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentWithNavigationController(_ newViewController: UIViewController, _ animated: Bool = false) {
        let navigationController = UINavigationController(rootViewController: newViewController)
        navigationController.modalPresentationStyle = .fullScreen
        // swiftlint:disable:next line_length
        navigationController.navigationBar.barStyle = (self.navigationController?.navigationBar.barStyle ?? .default)
        self.present(navigationController, animated: animated, completion: nil)
    }
    
    func present(_ newViewController: UIViewController, _ animated: Bool = false) {
        self.present(newViewController, animated: animated, completion: nil)
    }
    
}

public extension UINavigationController {
    
    func push(_ vC: UIViewController) {
        self.pushViewController(vC, animated: false)
    }
    
}
