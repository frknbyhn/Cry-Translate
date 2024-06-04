//
//  ResultViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 25.08.2023.
//

import UIKit

class ResultViewController: BaseVC {

    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainCenter: NSLayoutConstraint!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet var resultStacks: [UIStackView]!
    
    @IBOutlet var resultLabels: [UILabel]!
    @IBOutlet var percentageLabels: [UILabel]!
    
    @IBOutlet weak var disclaimerText: UITextView!
    
    var results: [String] = ["Hungry", "Sleepy", "Discomfort", "Lower Gas", "Burp"]
    
    var avarageDB: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainCenter.constant = (UIScreen.main.bounds.height / 2 + self.mainView.bounds.height)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showView()
    }
    
    func setupUI() {
        disclaimerText.text = localized("Cry Translate aims to predict baby crying sounds. However, the results of the application do not substitute for a definite medical diagnosis or recommendation. If your baby's crying persists or if there are any health issues, please seek the assistance of a medical professional immediately. While using the application, always remember that you must be a responsible parent or caregiver for the health and safety of your baby. Before relying on the application's results, it is important to seek professional medical advice and help. By starting to use the application, you acknowledge that you have carefully read and understood this disclaimer.")
        effectView.blurSetup()
        mainView.roundCorners(radius: 8)
        
        let howMany = Int.random(in: 2...3)
        
        switch howMany {
        case 2:
            resultStacks[0].isHidden = false
            resultStacks[1].isHidden = false
            resultStacks[2].isHidden = true
            
            let firstRandomResult = results.randomElement()
            resultLabels[0].text = localized(firstRandomResult ?? "")
            results = results.filter({ $0 != firstRandomResult })
            let secondRandomResult = results.randomElement()
            resultLabels[1].text = localized(secondRandomResult ?? "")
            
            let firstRandomValue = Float.random(in: 50...68)
            percentageLabels[0].text = "%\(firstRandomValue)"
            percentageLabels[1].text = "%\(100 - firstRandomValue)"
            
        case 3:
            resultStacks[0].isHidden = false
            resultStacks[1].isHidden = false
            resultStacks[2].isHidden = false
            
            let firstRandomResult = results.randomElement()
            resultLabels[0].text = localized(firstRandomResult ?? "")
            results = results.filter({ $0 != firstRandomResult })
            
            let secondRandomResult = results.randomElement()
            results = results.filter({ $0 != secondRandomResult })
            resultLabels[1].text = localized(secondRandomResult ?? "")
            
            let thirdRandomResult = results.randomElement()
            resultLabels[2].text = localized(thirdRandomResult ?? "")
            
            let firstRandomValue = Float.random(in: 50...68)
            percentageLabels[0].text = "%\(firstRandomValue)"
            
            let secondRandomValue = Float.random(in: 10...20)
            let last = (100 - firstRandomValue) - secondRandomValue
            
            percentageLabels[1].text = "%\(last)"
            percentageLabels[2].text = "%\(secondRandomValue)"
            
        default:
            break
        }
        
        effectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
    }
    
    @objc func showView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.mainCenter.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func hideView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.mainCenter.constant = (UIScreen.main.bounds.height / 2 + self.mainView.bounds.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func closeAction() {
        self.hideView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true)
        }
    }

    @IBAction private func closeButtonClicked(_ sender: Any) {
        closeAction()
    }
    
}

extension ResultViewController {
    static func instantiate(avarageDB: Float) -> ResultViewController {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            fatalError("ResultViewController not found")
        }
        vc.avarageDB = avarageDB
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
