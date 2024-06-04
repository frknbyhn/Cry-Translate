
import UIKit

extension UIImage {
    func frame(in imageView: UIView) -> CGRect {
        let imageRatio = (self.size.width / self.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / self.size.height
            let width = scale * self.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / self.size.width
            let height = scale * self.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }
    
    class func snapshot(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

