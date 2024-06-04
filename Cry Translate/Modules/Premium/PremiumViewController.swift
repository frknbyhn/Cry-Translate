//
//  PremiumViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit

class PremiumViewController: BaseVC {
    
    var premiumClosedProtocol: PremiumClosedProtocol?
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "colorCloseButton")?.withRenderingMode(.alwaysOriginal) ?? UIImage(), style: .plain, target: self, action: #selector(closeAction))
    }()
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var firstContentView: UIView!
    @IBOutlet weak var firstContentLabel: UILabel!
    @IBOutlet weak var secondContentView: UIView!
    @IBOutlet weak var secondContentLabel: UILabel!
    
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var continueLabel: UILabel!
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var monthlyChooseView: UIView!
    @IBOutlet weak var monthlyLabel: UILabel!
    
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var weeklyChooseView: UIView!
    @IBOutlet weak var weeklyLabel: UILabel!
    
    @IBOutlet weak var yearlyView: UIView!
    @IBOutlet weak var yearlyChooseView: UIView!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    @IBOutlet weak var disclaimerText: UITextView!
    
    enum ChoosenDuration {
        case month
        case weekly
        case yearly
    }
    
    var duration: ChoosenDuration = .weekly {
        didSet {
            if duration == .weekly {
                monthlyChooseView.backgroundColor = .white
                weeklyChooseView.backgroundColor = UIColor(named: "firstColor")
                yearlyChooseView.backgroundColor = .white
            } else if duration == .month {
                monthlyChooseView.backgroundColor = UIColor(named: "firstColor")
                weeklyChooseView.backgroundColor = .white
                yearlyChooseView.backgroundColor = .white
            } else {
                monthlyChooseView.backgroundColor = .white
                weeklyChooseView.backgroundColor = .white
                yearlyChooseView.backgroundColor = UIColor(named: "firstColor")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "appTitle"))
        navigationItem.rightBarButtonItem = closeButton
        setupUI()
    }
    
    func setupUI() {
        continueLabel.text = localized("SUBSCRIBE NOW")
        
        firstContentView.roundCorners(radius: 16)
        secondContentView.roundCorners(radius: 16)
        
        duration = .yearly
        
        monthlyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monthlyAction)))
        weeklyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weeklyAction)))
        yearlyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yearlyAction)))
        
        monthlyView.roundCorners(radius: 16)
        weeklyView.roundCorners(radius: 16)
        yearlyView.roundCorners(radius: 16)
        
        weeklyChooseView.roundCorners(radius: weeklyChooseView.layer.bounds.width / 2)
        monthlyChooseView.roundCorners(radius: monthlyChooseView.layer.bounds.width / 2)
        yearlyChooseView.roundCorners(radius: yearlyChooseView.layer.bounds.width / 2)
        
        disclaimerText.text = localized("Cry Translate aims to predict baby crying sounds. However, the results of the application do not substitute for a definite medical diagnosis or recommendation. If your baby's crying persists or if there are any health issues, please seek the assistance of a medical professional immediately. While using the application, always remember that you must be a responsible parent or caregiver for the health and safety of your baby. Before relying on the application's results, it is important to seek professional medical advice and help. By starting to use the application, you acknowledge that you have carefully read and understood this disclaimer.")
        
        if let color = UIColor(named: "firstColor")?.cgColor {
            monthlyView.setBorder(color: color)
            weeklyView.setBorder(color: color)
            yearlyView.setBorder(color: color)
            weeklyChooseView.setBorder(color: color)
            monthlyChooseView.setBorder(color: color)
            yearlyChooseView.setBorder(color: color)
        }
        
        weeklyLabel.text = "\(localized("Weekly Premium")) $5.99"
        monthlyLabel.text = "\(localized("Monthly Premium")) $14.99"
        yearlyLabel.text = "\(localized("Yearly Premium")) $49.99"
        
        continueView.roundCorners(radius: 16)
        
        privacyButton.setTitle(localized("Privacy Policy"), for: .normal)
        termsButton.setTitle(localized("Terms of Use"), for: .normal)
        restoreButton.setTitle(localized("Restore"), for: .normal)
        firstContentLabel.text = localized("Baby Cry Analysis with Advanced Artificial Intelligence")
        secondContentLabel.text = localized("Subscribe for unlimited baby cry translation.\n\nUpgrade for AI-Enhanced Baby Cry Insights. Instantly decode your baby's cries with premium AI analysis. Elevate your parenting with cutting-edge technology.")
        
        continueView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(purchasePremium)))
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        continueView.layer.add(pulse, forKey: nil)
    }
    
    @objc func purchasePremium() {
        var preID: String = Config.weeklyID
        
        switch duration {
        case .weekly:
            preID = Config.weeklyID
        case .month:
            preID = Config.monthlyID
        case .yearly:
            preID = Config.yearlyID
        }
            
        showLoader()
        SwiftyStoreKit.purchaseProduct(preID, atomically: true) { result in
            switch result {
            case .success(_):
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.setPro), userInfo: nil, repeats: false)
            case .error(_):
                self.hideLoader()
                let alert: UIAlertController = UIAlertController(title: localized("Error"),
                                                                 message: localized("Purchase failed, there was an error occured"),
                                                                 preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: localized("Okay"), style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func setPro() {
        hideLoader()
        setPremium()
        StarterHelper.startPage(.main)
    }
    
    func checkPremiumServices() {
        showLoader()
        PremiumServices.checkPremium(premiumID: Config.weeklyID) { (weeklyStatus) in
            if weeklyStatus {
                self.setPro()
            } else {
                PremiumServices.checkPremium(premiumID: Config.monthlyID) { (monthlyStatus) in
                    if monthlyStatus {
                        self.setPro()
                    } else {
                        PremiumServices.checkPremium(premiumID: Config.yearlyID) { (yearlyStatus) in
                            if yearlyStatus {
                                self.setPro()
                            } else {
                                self.unsetPremium()
                                self.hideLoader()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setPremium() {
        UserDefaults.standard.set(true, forKey: "Premium")
    }
    
    func unsetPremium() {
        UserDefaults.standard.set(false, forKey: "Premium")
        let vc = NoHandlerPopupViewController.instantiate(main: "No Package", desc: "There is no purchased package")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyButtonClicked(_ sender: Any) {
        AllHelper.open(link: Config.privacyLink)
    }
    
    @IBAction func termsButtonClicked(_ sender: Any) {
        AllHelper.open(link: Config.termsLink)
    }
    
    @IBAction func restoreButtonClicked(_ sender: Any) {
        checkPremiumServices()
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true) {
            self.premiumClosedProtocol?.premiumClosed()
        }
    }
    
    @objc func weeklyAction() {
        duration = .weekly
    }
    
    @objc func monthlyAction() {
        duration = .month
    }
    
    @objc func yearlyAction() {
        duration = .yearly
    }
    
}

extension PremiumViewController {
    static func instantiate(delegate: PremiumClosedProtocol?) -> PremiumViewController {
        let storyboard = UIStoryboard(name: "Premium", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController else {
            fatalError("PremiumViewController not found")
        }
        vc.premiumClosedProtocol = delegate
        return vc
    }
}
