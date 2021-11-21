//
//  ViewController.swift
//  BoostMusicPlayer
//
//  Created by 유정주 on 2021/11/17.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {

    //MARK: - Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    
    //MARK: - IBOutlet
    @IBOutlet var playPuaseButton: UIButton! //재생,일시정지 버튼
    @IBOutlet var timeLabel: UILabel! //시간초 레이블
    @IBOutlet var progressSlider: UISlider! //진행 슬라이더
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.addViewWithCode()
        self.initializePlayer()
    }
    
    //MARK: - Methods
    //MARK: Custom Methods
    func initializePlayer() {
        guard let soundAssets:NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 애셋을 가져올 수 없습니다.")
            return
        }

        do {
            try self.player = AVAudioPlayer(data: soundAssets.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("code: \(error.code) / message: \(error.localizedDescription)")
        }
        
        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        print("called updateTimeLabelText -> time: \(time)")
        
        let minute: Int = Int(time / 60)
        //Returns the remainder of this value divided by the given value using truncating division.
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        //unowned: ARC를 위함.
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            //Slider를 움직이는 동안은 음원이 계속 재생된다.
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
    }
    
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    func addViewWithCode() {
        self.addPlayPauseButton()
        self.addTimeLabel()
        self.addProgressSlider()
    }
    
    func addPlayPauseButton() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(button)
        
        button.setImage(UIImage(named: "button_play"), for: UIControl.State.normal)
        button.setImage(UIImage(named: "button_pause"), for: UIControl.State.selected)
        
        button.addTarget(self, action: #selector(self.touchUpPlayPauseButton(_:)), for: UIControl.Event.touchUpInside)
        
        let centerX: NSLayoutConstraint
        centerX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)

        let centerY: NSLayoutConstraint
        centerY = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.8, constant: 0)

        let width: NSLayoutConstraint
        width = button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)

        let ratio: NSLayoutConstraint
        ratio = button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1)

        centerX.isActive = true
        centerY.isActive = true
        width.isActive = true
        ratio.isActive = true

        self.playPuaseButton = button
    }
    
    func addTimeLabel() {
        let timeLabel: UILabel = UILabel()
        //A Boolean value that determines whether the view’s autoresizing mask is translated into Auto Layout constraints.
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(timeLabel)
        
        timeLabel.textColor = UIColor.black
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        
        let centerX: NSLayoutConstraint
        centerX = timeLabel.centerXAnchor.constraint(equalTo: self.playPuaseButton.centerXAnchor)
        
        let top: NSLayoutConstraint
        top = timeLabel.topAnchor.constraint(equalTo: self.playPuaseButton.bottomAnchor, constant: 8)
        
        centerX.isActive = true
        top.isActive = true
        
        self.timeLabel = timeLabel
        self.updateTimeLabelText(time: 0)
    }
    
    func addProgressSlider() {
        let slider: UISlider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(slider)
        
        slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        let safeAreaGuide: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        let centerX: NSLayoutConstraint
        centerX = slider.centerXAnchor.constraint(equalTo: self.timeLabel.centerXAnchor)
        
        let top: NSLayoutConstraint
        top = slider.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 8)
        
        let leading: NSLayoutConstraint
        leading = slider.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16)
        
        let trailing: NSLayoutConstraint
        trailing = slider.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16)
    
        centerX.isActive = true
        top.isActive = true
        leading.isActive = true
        trailing.isActive = true
        
        self.progressSlider = slider
    }
    
    
    //MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.makeAndFireTimer()
        } else {
            self.player?.pause()
            self.invalidateTimer()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentTime = TimeInterval(sender.value)
        
        self.updateTimeLabelText(time: currentTime)
        //Slider를 움직이는 동안은 음원이 계속 재생된다.
        if sender.isTracking { return }
        
        self.player.currentTime = currentTime
    }
 
    
    //MARK: - AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error:Error = error else {
            print("오디오 플레이어 디코드 오류 발생")
            return
        }
        
        let message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPuaseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
}

