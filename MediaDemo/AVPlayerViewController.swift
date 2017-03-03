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
  
  var playerItem: AVPlayerItem = {
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    path = path?.appending("/capture.mp4")
    return AVPlayerItem(url: URL(fileURLWithPath: path!))
  }()
  
  var player: AVPlayer!
  
  deinit {
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
    
    player.play()
  }
  
  private func addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(playbackFinish(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
  }
  
  private func removeObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func addProgressObserver() {
    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [unowned self] (time) in
      let current: Float = Float(time.seconds)
      let total: Float = Float(self.playerItem.duration.seconds)
      print(current, total)
      self.progressView.progress = current / total
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
      
      
    }
  }
  
  @objc private func playbackFinish(note: Notification) {
    print("视频播放完成")
  }
  
}
