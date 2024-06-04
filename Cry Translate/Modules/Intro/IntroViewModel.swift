//
//  IntroViewModel.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 25.08.2023.
//

import Foundation
import UIKit

final class IntroViewModel {
    
    var continueButtonLower : String {
        return localized("Continue")
    }
    
    var continueButtonLetsStart : String {
        return localized("Let's Start")
    }
    
    let introTitle : [String] = [localized("Working Principle"),
                                 localized("User Feedback")]
    let introContent : [String] = [localized("The AI feature is a system that analyzes baby crying sounds. This system trains an artificial intelligence model that can make predictions for different need categories (hunger, discomfort, insomnia, etc.) by processing the collected cry sounds data. The model converts the sound data into feature vectors and predicts the type of crying from these vectors."),
                                   localized("By seeing these predictions, users can respond more quickly to baby's needs. The model is constantly improved with user feedback and data, tending towards more precise results.")]
    
    var titleView : UIImageView {
        return UIImageView(image: UIImage(named: "appTitle"))
    }
    
    var introCellId : String {
        return "IntroCollectionViewCell"
    }
    
    var buttonRadius: CGFloat {
        return 25
    }
    
    public var rightInset: CGFloat {
        return 0
    }
    
    public var leftInset: CGFloat {
        return 0
    }
    
    public var topInset: CGFloat {
        return 0
    }
    
    public var bottomInset: CGFloat {
        return 0
    }
    
    public var minimumInteritemSpacing: CGFloat {
        return 0
    }
    
    public var minimumLineSpacing: CGFloat { //same row spacing
        return 0
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = self.minimumInteritemSpacing
        layout.minimumLineSpacing = self.minimumLineSpacing
        layout.sectionInset.top = self.topInset
        layout.sectionInset.bottom = self.bottomInset
        layout.sectionInset.left = self.leftInset
        layout.sectionInset.right = self.rightInset
        layout.scrollDirection = .horizontal
        return layout
    }
    
}


