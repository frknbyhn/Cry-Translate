
import Foundation
import UIKit

extension UIView {
    
    func roundCorners(onlyBottom : Bool = false, onlyTop : Bool = false, all : Bool = true, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        
        if onlyBottom {
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if onlyTop {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
    }
    
    func blurSetup() {
        let blurView = UIVisualEffectView()
        blurView.frame = self.bounds
        blurView.backgroundColor = UIColor.black.withAlphaComponent(1)
        blurView.alpha = 0.6
        self.addSubview(blurView)
    }
    
    func setBorder(width: CGFloat = 1, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
}
