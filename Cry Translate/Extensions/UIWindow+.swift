import UIKit

extension UIWindow {
    func switchRoot(to viewController: UIViewController, animated: Bool ,duration: TimeInterval,options: UIView.AnimationOptions, _ completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let animationState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(animationState)
        }, completion: { _ in
            completion?()
        })
    }
}

