//
//  PlayViewController.swift
//  MediaDemo
//
//  Created by iosci on 2017/3/1.
//  Copyright © 2017年 secoo. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayViewController: UIViewController {

  var playURL: URL?
  
  lazy var moviePlayer: MPMoviePlayerController = {
    let pc = MPMoviePlayerController(contentURL: self.playURL)
    return pc!
  }()
  
  deinit {
    _removeObserver()
    moviePlayer.stop()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    _addObserver()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
    _addObserver()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(moviePlayer.view)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    moviePlayer.play()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    moviePlayer.view.frame = CGRect(x: 0, y: 70, width: view.bounds.size.width, height: 300)
  }
  
  private func _addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(_enterFullScreen), name: .MPMoviePlayerWillEnterFullscreen, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(_exitFullScreen), name: .MPMoviePlayerWillExitFullscreen, object: nil)
  }
  
  private func _removeObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func _enterFullScreen() {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  @objc private func _exitFullScreen() {
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
}
