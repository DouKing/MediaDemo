//
//  TestViewController.swift
//  MediaDemo
//
//  Created by iosci on 2017/6/6.
//  Copyright © 2017年 secoo. All rights reserved.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {

  @IBOutlet weak var playerView2: UIView!
  @IBOutlet weak var playerView1: UIView!

  @IBOutlet weak var play1: UIButton!
  @IBOutlet weak var play2: UIButton!

  let playerItem1: AVPlayerItem = AVPlayerItem(url: URL(string: "http://baobab.wdjcdn.com/14559682994064.mp4")!)
  let playerItem2: AVPlayerItem = AVPlayerItem(url: URL(string: "http://baobab.wdjcdn.com/1458625865688ONE.mp4")!)

  lazy var player1: AVPlayer = {
    return AVPlayer(playerItem: self.playerItem1)
  }()

  lazy var player2: AVPlayer = {
    return AVPlayer(playerItem: self.playerItem2)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    let playerLayer1 = AVPlayerLayer(player: player1)
    playerLayer1.frame = playerView1.bounds
    playerView1.layer.addSublayer(playerLayer1)

    let playerLayer2 = AVPlayerLayer(player: player2)
    playerLayer2.frame = playerView2.bounds
    playerView2.layer.addSublayer(playerLayer2)
  }

  @IBAction func play1(_ sender: UIButton) {
    if player1.rate > 0 {
      player1.pause()
    } else {
      player2.pause()
      player1.play()
    }
  }

  @IBAction func play2(_ sender: Any) {
    if player2.rate > 0 {
      player2.pause()
    } else {
      player1.pause()
      player2.play()
    }
  }

}
