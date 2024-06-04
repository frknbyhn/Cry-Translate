

import UIKit
import Foundation
import Lottie
import CoreLocation

class AppUtility: NSObject {
    
    static let ScreenHeight = UIScreen.main.bounds.height
    static let ScreenWidth = UIScreen.main.bounds.width
    
    class func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
          let currentContext = UIGraphicsGetCurrentContext()
          currentContext?.saveGState()
          defer { currentContext?.restoreGState() }
          let size = rect.size
          UIGraphicsBeginImageContextWithOptions(size, false, 0)
          guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                          colors: colors as CFArray,
                                          locations: nil) else { return nil }
          let context = UIGraphicsGetCurrentContext()
          context?.drawLinearGradient(gradient,
                                      start: CGPoint.zero,
                                      end: CGPoint(x: size.width, y: 0),
                                      options: [])
          let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          guard let image = gradientImage else { return nil }
          return UIColor(patternImage: image)
    }
    
    class func setAnimation(animationName: String, loop: Bool, myView: UIView) {
        let animationView = AnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFill
        if !loop {
            animationView.loopMode = .playOnce
        } else {
            animationView.loopMode = .loop
        }
        animationView.tag = 100
        myView.addSubview(animationView)
        animationView.play()
    }
    
    class func createAnimationView(animationName: String, loop: Bool) -> AnimationView {
        let animationView = AnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        if !loop {
            animationView.loopMode = .playOnce
        } else {
            animationView.loopMode = .loop
        }
        return animationView
    }
    
    class func radiusView(view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.height / 2
        
        view.layer.borderColor = AppUtility.UIColorFromRGB(0x4D4BEC).cgColor
        view.layer.borderWidth = 4
    }
    
    class func jumpView(view: UIView) {
        UIView.animate(withDuration: 0.40) {
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    class func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func isLocationServiceEnabled() -> String {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return "notAllowed"
            case .authorizedWhenInUse:
                return "whenUsing"
            case .authorizedAlways:
                return "always"
            default:
                return "notAllowed"
            }
        }else{
            return "notAllowed"
        }
    }

    class func goURL(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.openURL(url)
    }
    
}

