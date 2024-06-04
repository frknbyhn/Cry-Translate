//
//  MainViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import LDProgressView

protocol GoSettingsProtocol: AnyObject {
    func goSettings()
}

class MainViewController: BaseVC, StoryboardLoadable, AVAudioRecorderDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var infoButton: UIBarButtonItem = {
        let image = UIImage(named: "whiteInfoIcon")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(infoAction))
        button.tintColor = .white
        return button
    }()
    
    private lazy var diamondButton: UIBarButtonItem = {
        let image = UIImage(named: "diamond")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(premiumAction))
        button.tintColor = .white
        return button
    }()
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var progressView: LDProgressView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var decibelLabel: UILabel!
    
    let audioManager = DecibelManager()
    
    var audioRecorder: AVAudioRecorder!
    
    var levelTimer: Timer?
    
    var decibels: [Float]? = [] {
        didSet {
            let floatCount = CGFloat(decibels?.count ?? 0)

            progressView.progress = floatCount / 10
            
            if decibels?.count == 10 {
                recordComplete()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        if !UserDefaults.standard.bool(forKey: "Premium") {
            navigationItem.leftBarButtonItem = diamondButton
        }
        startLabel.text = localized("Start Recording")
        setupProgressView()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "whiteAppTitle"))
        navigationItem.rightBarButtonItem = infoButton
        recordView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startRecording)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleMicrophonePermissionStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
        }
        levelTimer?.invalidate()
        recordImageView.image = UIImage(named: "startIcon")
        progressView.isHidden = true
        decibelLabel.isHidden = true
        progressView.progress = 0
        startLabel.text = localized("Start Recording")
        decibels?.removeAll()
    }
    
    @objc func infoAction() {
        let nc = BaseNav(rootViewController: VideoPlayViewController.instantiate())
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .coverVertical
        self.present(nc, animated: true, completion: nil)
    }
    
    func setupProgressView() {
        progressView.isHidden = true
        decibelLabel.isHidden = true
        progressView.animate = NSNumber(booleanLiteral: true)
        progressView.type = LDProgressSolid
        progressView.background = .clear
        progressView.borderRadius = 16
        progressView.showText = NSNumber(booleanLiteral: true)
        progressView.color = .white
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                self.setupAudioRecorder()
            } else {
                DispatchQueue.main.async {
                    let vc = GoSettingsViewController.instantiate()
                    vc.goSettingsProtocol = self
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func handleMicrophonePermissionStatus() {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        
        switch permissionStatus {
        case .granted:
            setupAudioRecorder()
        case .denied:
            DispatchQueue.main.async {
                let vc = GoSettingsViewController.instantiate()
                vc.goSettingsProtocol = self
                self.present(vc, animated: true, completion: nil)
            }
        case .undetermined:
            requestMicrophonePermission()
        @unknown default:
            fatalError("Unhandled case")
        }
    }

    
    func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    @objc func startRecording() {
        
        if AVAudioSession.sharedInstance().recordPermission == .granted {
            if let audioRecorder = audioRecorder {
                if !audioRecorder.isRecording {
                    if UserDefaults.standard.bool(forKey: "Premium") {
                        progressView.progress = 0
                        startLabel.text = localized("Start Recording")
                        decibels?.removeAll()
                        progressView.isHidden = false
                        decibelLabel.isHidden = false
                        audioRecorder.record()
                        levelTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAudioLevel), userInfo: nil, repeats: true)
                        recordImageView.image = UIImage(named: "stopIcon")
                    } else {
                        if UserDefaults.standard.bool(forKey: "Star") {
                            self.goPre()
                        } else {
                            let vc = ChoiceViewController.instantiate(delegate: self)
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                } else {
                    audioRecorder.stop()
                    levelTimer?.invalidate()
                    recordImageView.image = UIImage(named: "startIcon")
                    progressView.isHidden = true
                    decibelLabel.isHidden = true
                    progressView.progress = 0
                    startLabel.text = localized("Start Recording")
                    decibels?.removeAll()
                }

            }
        } else {
            handleMicrophonePermissionStatus()
        }
    }
    
    @objc func updateAudioLevel() {
        audioRecorder.updateMeters()
        let decibel = audioRecorder.averagePower(forChannel: 0)
        decibelLabel.text = "\(localized("Decibel")): \(decibel) db"
        if decibel > -15 {
            decibels?.append(decibel)
            startLabel.text = localized("Sound detected, keep recording")
        } else {
            startLabel.text = localized("No sound, bring the microphone closer")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func recordComplete() {
        showLoader()
        audioRecorder.stop()
        levelTimer?.invalidate()
        recordImageView.image = UIImage(named: "startIcon")
        
        var avarage: Float = 0
        decibels?.forEach({ value in
            avarage += value
        })
        
        progressView.isHidden = true
        decibelLabel.isHidden = true
        progressView.progress = 0
        startLabel.text = localized("Start Recording")
        decibels?.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideLoader()
            let lastAvarage = avarage / 10
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let vc = ResultViewController.instantiate(avarageDB: lastAvarage)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func premiumAction() {
        self.goPre()
    }
    
}

extension MainViewController: ChoiceMadedProtocol {
    func openAd() {
        self.showRewardedAd(root: self) { didEarn, rewarded in
            if didEarn {
                rewarded.fullScreenContentDelegate = self
            }
        }
    }
    
    func openPre() {
        self.goPre()
    }
}

extension MainViewController : GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        progressView.progress = 0
        startLabel.text = localized("Start Recording")
        decibels?.removeAll()
        progressView.isHidden = false
        decibelLabel.isHidden = false
        audioRecorder.record()
        levelTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAudioLevel), userInfo: nil, repeats: true)
        recordImageView.image = UIImage(named: "stopIcon")
    }
}

extension MainViewController: GoSettingsProtocol {
    func goSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
        }
    }
}
