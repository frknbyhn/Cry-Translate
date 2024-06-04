
import UIKit
import StoreKit

class AllHelper {
    
    static func rateUs() {
        SKStoreReviewController.requestReview()
        UserDefaults.standard.set(true, forKey: "Rated")
    }
    
    static func open(link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func share(text:String, root:UIViewController) {
        let avc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        avc.excludedActivityTypes = [.saveToCameraRoll,.message, .mail, .markupAsPDF, .airDrop, .addToReadingList, .copyToPasteboard, .assignToContact]
        avc.popoverPresentationController?.sourceView = root.view
        root.present(avc, animated: true, completion: nil)
    }
    
    static func share(data:Data, root:UIViewController) {
        let avc = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        avc.popoverPresentationController?.sourceView = root.view
        root.present(avc, animated: true, completion: nil)
    }
    
    static func shareImage(image:UIImage, root:UIViewController, completion: @escaping () -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let avc = UIActivityViewController(activityItems: [imageData], applicationActivities: nil)
        avc.completionWithItemsHandler = { activity, success, items, error in
            if let activityItem = activity {
                if activityItem.rawValue == "com.apple.UIKit.activity.SaveToCameraRoll" {
                    completion()
                }
            }
        }
        avc.popoverPresentationController?.sourceView = root.view
        root.present(avc, animated: true, completion: nil)
    }
    
    static func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    static func haptic() {
        if UserDefaults.standard.bool(forKey: "Vibration") {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

