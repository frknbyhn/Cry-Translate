
import UIKit

class StarterHelper: NSObject {
    
    enum PageType {
        case main
        case intro
        func getSelectedVC() -> UIViewController {
            switch self {
            case .main: return UIStoryboard.loadViewController(.Main) as MainViewController
            case .intro: return UIStoryboard.loadViewController(.Intro) as IntroViewController
            }
        }
    }
    
    static func startPage(_ type: PageType) {
        UIApplication.shared.keyWindow?.switchRoot(to: BaseNav(rootViewController: type.getSelectedVC()),
                                                   animated: true,
                                                   duration: 0.5,
                                                   options: .transitionCrossDissolve)
    }
    
    static func checkInitial() {
        if UserDefaults.standard.bool(forKey: "SeenIntro") {
            self.startPage(.main)
        } else {
            self.startPage(.intro)
        }
    }
}

