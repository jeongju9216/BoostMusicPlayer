//
//  ViewController.swift
//  BoostMusicPlayer
//
//  Created by 유정주 on 2021/11/17.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet var playPuaseButton: UIButton! //재생,일시정지 버튼
    @IBOutlet var timeLabel: UILabel! //시간초 레이블
    @IBOutlet var progressSlider: UISlider! //진행 슬라이더
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

