//
//  InfoViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 25.08.2023.
//

import UIKit

class IntroViewController: BaseVC, StoryboardLoadable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    let viewModel = IntroViewModel()
    
    var currentPage = 0 {
        didSet {
            var videoName = String()
            var buttonText = String()
            var mainText = String()
            var contentText = String()
            
            switch currentPage {
            case 0:
                buttonText = viewModel.continueButtonLower
                videoName = "intro0"
                mainText = viewModel.introTitle[0]
                contentText = viewModel.introContent[0]
            case 1:
                buttonText = viewModel.continueButtonLetsStart
                videoName = "intro1"
                mainText = viewModel.introTitle[1]
                contentText = viewModel.introContent[1]
            default:
                break
            }
            setAnimation(view: videoView, name: videoName, loop: true)
            mainLabel.text = mainText
            contentLabel.text = contentText
            continueButton.setTitle(buttonText, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.titleView = self.viewModel.titleView
        setupUI()
    }
    
    func setupUI() {
        currentPage = 0
        continueButton.setTitle(viewModel.continueButtonLower, for: .normal)
        continueButton.roundCorners(radius: self.viewModel.buttonRadius)
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        if currentPage == 1 {
            StarterHelper.startPage(.main)
            UserDefaults.standard.set(true, forKey: "SeenIntro")
        } else {
            currentPage += 1
        }
    }
    
}
