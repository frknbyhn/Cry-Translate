
import Foundation
import UIKit

extension UITableViewCell {
    static var id:String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var id:String {
        return String(describing: self)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, withReuseIdentifier identifier: String? = nil, for indexPath: IndexPath) -> T {
        let identifier = identifier ?? String(describing: type)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

