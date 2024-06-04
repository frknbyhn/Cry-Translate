//
//  BaseVC.swift
//  LogicQR
//
//  Created by Furkan BEYHAN on 1.09.2022.
//

import UIKit
import Lottie
import AVFoundation
import AVKit
import StoreKit
import GoogleMobileAds

class BaseVC: UIViewController {
    
    var animationView: AnimationView?
    
    var rewarded : GADRewardedInterstitialAd?
    var rewardCount : Int = 0
    var watchedAd : Int = 0
    var firstAd : GADInterstitialAd?
    
    var defaultHeight:CGFloat = 0.0
    var topBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return 44
        }
    }
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        defaultHeight = self.view.frame.size.height
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.defaultHeight - keyboardHeight + 70)
        }
    }
    
    @objc func keyboardWillDisappear(notification:NSNotification) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.defaultHeight)
    }
    
    @objc func setAnimation(view: UIView, name: String, loop: Bool) {
        if let animateTag = view.viewWithTag(202) {
            animateTag.removeFromSuperview()
        }
        animationView = AppUtility.createAnimationView(animationName: name, loop: loop)
        animationView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView?.tag = 202
        
        self.animationView?.reloadImages()
        view.insertSubview(self.animationView!, at: 0)
        self.animationView?.play()
        self.animationView?.backgroundBehavior = .pauseAndRestore
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.main) { (_) in
            self.animationView?.play()
        }
    }
    
    func get64FromImage(image : UIImage) -> String? {
        let imageData = image.pngData()
        let base64 = imageData?.base64EncodedString()
        return base64
    }
    
    func formatDate(stringDate: String, fromFormat: String = "yyyy-MM-dd HH:mm:ss", toFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let formatted = formatter.date(from: stringDate) ?? Date()
        formatter.dateFormat = toFormat
        formatter.timeZone = TimeZone.current
        return formatter.string(from: formatted)
    }
    
    func centerShow(mainCenter : NSLayoutConstraint, view : UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                mainCenter.constant = 0
                view.layoutIfNeeded()
            }
        }
    }
    
    func centerHide(mainView : UIView, mainCenter : NSLayoutConstraint, view : UIView, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                mainCenter.constant = (UIScreen.main.bounds.height / 2 + mainView.bounds.height)
                view.layoutIfNeeded()
            } completion: { stat in
                completion()
            }
        }
    }
    
    func bottomShow(mainBottom : NSLayoutConstraint, view : UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                mainBottom.constant = 0
                view.layoutIfNeeded()
            }
        }
    }
    
    func bottomHide(mainView : UIView, mainBottom : NSLayoutConstraint, view : UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                mainBottom.constant = -mainView.bounds.height
                view.layoutIfNeeded()
            }
        }
    }
    
    func setNavTitle(imageName: String) {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: imageName))
    }
    
    func setTitleToNavBar(text: String, color: UIColor) {
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "\(text)"
        label.textColor = color
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Muli-Bold", size: 16)
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        navView.addSubview(label)
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }
    
    func shareApp(presentedView: UIView) -> UIActivityViewController {
        let text = Config.appUrl
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = presentedView
        return activityViewController
    }
    
    func showToast(message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 16;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Muli-SemiBold", size: 16)!
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: toastContainer, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
        let lableBottom = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let lableTop = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([centerX, lableBottom, lableTop])
        
        let containerCenterX = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let containerTrailing = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .equal, toItem: toastLabel, attribute: .width, multiplier: 1.2, constant: 0)
        let containerBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
        self.view.addConstraints([containerCenterX,containerTrailing, containerBottom])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    func imageToBase64 (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func base64ToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image ?? UIImage()
    }
    
    func openNoHandler(main : String, desc : String) {
        let vc = NoHandlerPopupViewController.instantiate(main: main, desc: desc)
        self.present(vc, animated: true, completion: nil)
    }
    
    func changeDateFormat(dateString: String, fromFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = fromFormat
        let formattedDate = inputDateFormatter.date(from: dateString)
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = toFormat
        return outputDateFormatter.string(from: formattedDate ?? Date())
    }
    
    func goPre() {
        let nc = BaseNav(rootViewController: PremiumViewController.instantiate(delegate: nil))
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .coverVertical
        self.present(nc, animated: true, completion: nil)
    }
    
}

extension BaseVC: AVPlayerViewControllerDelegate {
    
    func videoPlay(videoName: String, videoView: UIView) {
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        let bundle = Bundle.main
        let moviePath: String? = bundle.path(forResource: videoName, ofType: "mp4")
        let movieURL = URL(fileURLWithPath: moviePath ?? "")
        player = AVPlayer(url: movieURL)
        player.isMuted = true
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerController.player = player
        self.addChild(playerController)
        videoView.addSubview(playerController.view)
        playerController.view.frame = videoView.frame
        playerController.showsPlaybackControls = false
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        player.play()
    }
    
}

extension BaseVC {
    
    func showRewardedAd(root: UIViewController, completion: @escaping (Bool, GADRewardedInterstitialAd) -> Void) {
        self.showLoader()
        GADRewardedInterstitialAd.load(withAdUnitID: AdKeys.rewarded, request: GADRequest()) { rewardedAd, error in
            DispatchQueue.main.async {
                self.hideLoader()
                if error == nil {
                    self.rewarded = rewardedAd
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.rewarded?.present(fromRootViewController: root, userDidEarnRewardHandler: {
                            if let rewarded = self.rewarded {
                                completion(true, rewarded)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}
