

import Foundation
import UIKit

extension String {
    
    func getTextSize(widthLimit:CGFloat, font: UIFont) -> CGRect {
        let size = CGSize(width: widthLimit, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
    
    func uppercaseFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func uppercaseFirst() {
        self = self.uppercaseFirst()
    }
}

func localized(_ key:String) -> String {
    return NSLocalizedString(key, comment: "")
}

func getDeviceLanguage() -> String {
    let prefferedLanguage = Locale.preferredLanguages[0] as String
    let arr = prefferedLanguage.components(separatedBy: "-")
    let deviceLanguage = arr.first
    return deviceLanguage ?? ""
}

