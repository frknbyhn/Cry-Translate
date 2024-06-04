//
//  VideoPlayViewController.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 25.08.2023.
//

import UIKit
import VIMVideoPlayer

class VideoPlayViewController: BaseVC, VIMVideoPlayerViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var closeButton: UIBarButtonItem = {
        let image = UIImage(named: "closeButton")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeAction))
        button.tintColor = .white
        return button
    }()
    
    @IBOutlet weak var videoPlayerView: VIMVideoPlayerView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sampleLabel: UILabel!
    
    private var isScrubbing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.rightBarButtonItem = closeButton
        sampleLabel.text = localized("Dunstan Baby Language")
        setupVideoPlayerView()
        setupSlider()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoPlayerView.player = nil
        videoPlayerView.delegate = nil
    }
    
    private func setupVideoPlayerView() {
        
        videoPlayerView.player.isLooping = true
        videoPlayerView.player.enableAirplay()
        videoPlayerView.setVideoFillMode("AVLayerVideoGravityResizeAspectFill")
        
        videoPlayerView.delegate = self
        
        if let path = Bundle.main.path(forResource: "DunstanVideo", ofType: "mp4") {
            videoPlayerView.player.setURL(NSURL(fileURLWithPath: path) as URL)
        } else {
            assertionFailure("Video file not found!")
        }
    }
    
    private func setupSlider() {
        slider.addTarget(self, action: #selector(scrubbingDidStart), for: .touchDown)
        slider.addTarget(self, action: #selector(scrubbingDidChange), for: .valueChanged)
        slider.addTarget(self, action: #selector(scrubbingDidEnd), for: .touchUpInside)
        slider.addTarget(self, action: #selector(scrubbingDidEnd), for: .touchUpOutside)
    }
    
    @IBAction func didTapPlayPauseButton(sender: UIButton) {
        if videoPlayerView.player.isPlaying {
            sender.isSelected = true
            
            videoPlayerView.player.pause()
        } else {
            sender.isSelected = false
            
            videoPlayerView.player.play()
        }
    }
    
    @objc func scrubbingDidStart() {
        isScrubbing = true
        
        videoPlayerView.player.startScrubbing()
    }
    
    @objc func scrubbingDidChange() {
        guard let duration = videoPlayerView.player.player.currentItem?.duration, isScrubbing else {
            return
        }
        
        let time = Float(CMTimeGetSeconds(duration)) * slider.value
        
        videoPlayerView.player.scrub(time)
    }
    
    @objc func scrubbingDidEnd() {
        videoPlayerView.player.stopScrubbing()
        
        isScrubbing = false
    }
    
    func videoPlayerViewIsReady(toPlayVideo videoPlayerView: VIMVideoPlayerView?) {
        videoPlayerView?.player.play()
    }
    
    func videoPlayerView(_ videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        guard let duration = videoPlayerView.player.player.currentItem?.duration, !isScrubbing else {
            return
        }
        
        let durationInSeconds = Float(CMTimeGetSeconds(duration))
        let timeInSeconds = Float(CMTimeGetSeconds(cmTime))
        
        slider.value = timeInSeconds / durationInSeconds
    }
    
    @objc func closeAction() {
        dismiss(animated: true)
    }
}

extension VideoPlayViewController {
    static func instantiate() -> VideoPlayViewController {
        let storyboard = UIStoryboard(name: "VideoPlay", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as? VideoPlayViewController else {
            fatalError("VideoPlayViewController not found")
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
}
