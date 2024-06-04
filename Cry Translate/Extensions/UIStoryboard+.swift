

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case Main
        case Intro
        var name: String {
            return rawValue
        }
    }
    
    static func loadViewController<T>(_ board: Storyboard) -> T where T: StoryboardLoadable, T: UIViewController {
        return UIStoryboard(name: board.name, bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier()) as! T
    }

    func instantiateViewController<T: UIViewController>(ofType _: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
}



protocol StoryboardLoadable {
    static func storyboardIdentifier() -> String
}

extension StoryboardLoadable where Self: UIViewController {
    static func storyboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension StoryboardLoadable where Self: UINavigationController {
    static func storyboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}

