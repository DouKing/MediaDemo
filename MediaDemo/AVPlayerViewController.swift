//
//  AVPlayerViewController.swift
//  MediaDemo
//
//  Created by iosci on 2017/3/1.
//  Copyright © 2017年 secoo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class AVPlayerViewController: UIViewController {
  
  @IBOutlet weak var playerView: UIView!
  @IBOutlet weak var playBtn: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  
  var timeObserver: Any?
  
  var playerItem: AVPlayerItem = {
    let url = URL(string: "https://pic12.secooimg.com/video/siku1205.mp4")
    return AVPlayerItem(url: url!)
  }()
  
  var player: AVPlayer!
  
  deinit {
    if let timeObserver = timeObserver {
      player.removeTimeObserver(timeObserver)
    }
    removeObserver()
    removeObserver(for: playerItem)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    player = AVPlayer(playerItem: playerItem)
    addObserver(for: playerItem)
    addProgressObserver()
    addObserver()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = playerView.bounds
    playerView.layer.addSublayer(playerLayer)
    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if #available(iOS 10.0, *) {
      if player.timeControlStatus == .paused {
        player.play()
      }
    } else {
      // Fallback on earlier versions
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    player.pause()
  }
  
  private func addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(playbackFinish(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
  }
  
  private func removeObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func addProgressObserver() {
    timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [unowned self] (time) in
      let current = time.seconds
      let total = self.playerItem.duration.seconds
      print(current, total)
      self.progressView.progress = Float(current / total)
    }
  }
  
  private func addObserver(for playerItem: AVPlayerItem) {
    playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
    playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new], context: nil)
  }
  
  private func removeObserver(for playerItem: AVPlayerItem) {
    playerItem.removeObserver(self, forKeyPath: "status")
    playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let kp = keyPath, let playerItem = object as? AVPlayerItem else { return }
    if kp == "status" {
      if let status = change?[.newKey] {
        let s = status as! Int
        if s == AVPlayerStatus.readyToPlay.rawValue {
          print("正在播放")
        }
      }
    } else if kp == "loadedTimeRanges" {
      let array = playerItem.loadedTimeRanges
      // 本次缓冲时间范围
      let timeRange = array.first as! CMTimeRange
      let start = timeRange.start.seconds
      let duration = timeRange.duration.seconds
      print("time range: start \(start), duration \(duration)")
      let totalBuffer = start + duration
      print("total buffer: \(totalBuffer)")
    }
  }
  
  @objc private func playbackFinish(note: Notification) {
    print("视频播放完成")
  }

  var isPlaying = false

  @IBAction func playOrPause(_ sender: UIButton) {
    if !isPlaying {
      player.play()
      sender.setTitle("暂停", for: .normal)
    } else {
      player.pause()
      sender.setTitle("播放", for: .normal)
    }

    isPlaying = !isPlaying
  }
  
}
