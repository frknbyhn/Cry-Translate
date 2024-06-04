

import UIKit

extension UIImagePickerController {
    static func show(type: UIImagePickerController.SourceType,editing: Bool, from: UIViewController, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, error: (() -> Void)?) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = type
            imagePicker.allowsEditing = editing
            from.present(imagePicker, animated: true, completion: nil)
        } else {
            error?()
        }
    }
}

