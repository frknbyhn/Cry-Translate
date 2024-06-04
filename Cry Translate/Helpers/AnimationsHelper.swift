

import UIKit

class AnimationsHelper {
    
    static func infinityLineAnimation(duration:TimeInterval, from: CGFloat, to: CGFloat) -> CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "position.y")
        pathAnimation.fromValue = from
        pathAnimation.toValue = to
        pathAnimation.autoreverses = true
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = .forwards
        pathAnimation.duration = duration
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        return pathAnimation
    }
    
    static func scaleItemAnimation(duration: TimeInterval, from: CGFloat, to: CGFloat) -> CAAnimationGroup {
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = (duration * 0.3) + 1
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.3
        scaleAnimation.values = [from, to]
        scaleAnimation.autoreverses = true
        scaleAnimation.fillMode = .forwards
        scaleAnimation.repeatCount = 4
        scaleAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        
        animationGroup.animations = [scaleAnimation, pulseAnimation]
        return animationGroup
    }
    
    static func gradientAnimation(view: UIView, colors: [UIColor]) {
        
        let gradientLayer = CAGradientLayer(layer: view.layer)
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1
        animation.fromValue = [0, 0.1]
        animation.toValue = [0, 1]
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        gradientLayer.add(animation, forKey: nil)
    }
}

