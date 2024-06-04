

import Foundation
import UIKit

class InsetLabel: UILabel {

    var inset = UIEdgeInsets(top: -2, left: 2, bottom: -2, right: 2)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }

}

