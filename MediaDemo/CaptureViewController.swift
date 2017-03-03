//
//  CaptureViewController.swift
//  MediaDemo
//
//  Created by iosci on 2017/3/1.
//  Copyright © 2017年 secoo. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CaptureViewController: UIViewController {

  var isCapturing = false
  
  lazy var captureSession: AVCaptureSession = {
    let videpDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let frameDuration = CMTime(seconds: 1, preferredTimescale: 60)
    var frameRateSupport = false
    for range in (videpDevice?.activeFormat.videoSupportedFrameRateRanges)! {
      if CMTimeCompare(frameDuration, (range as! AVFrameRateRange).minFrameDuration) == 1
        && CMTimeCompare(frameDuration, (range as! AVFrameRateRange).maxFrameDuration) == -1 {
        frameRateSupport = true
      }
    }
    if frameRateSupport {
      if let _ = try? videpDevice?.lockForConfiguration() {
        videpDevice?.activeVideoMinFrameDuration = frameDuration
        videpDevice?.activeVideoMaxFrameDuration = frameDuration
        videpDevice?.unlockForConfiguration()
      }
    }
    let videoDeviceInput = try? AVCaptureDeviceInput(device: videpDevice)
    
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice)
    
    let session = AVCaptureSession()
    
    if let dI = videoDeviceInput, session.canAddInput(dI) {
      session.addInput(dI)
    }
    
    if let dI = audioDeviceInput, session.canAddInput(dI) {
      session.addInput(dI)
    }
    
    if session.canAddOutput(self.movieFileOutput) {
      session.addOutput(self.movieFileOutput)
    }
    return session
  }()
  
  lazy var previewLayer: AVCaptureVideoPreviewLayer = {
    let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    return previewLayer!
  }()
  
  lazy var movieFileOutput: AVCaptureMovieFileOutput = {
    return AVCaptureMovieFileOutput()
  }()

  var capturePathURL: URL {
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    path = path?.appending("/capture.mp4")
    print(path!)
    return URL(fileURLWithPath: path!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.insertSublayer(previewLayer, at: 0)
    captureSession.startRunning()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = view.bounds
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nav = segue.destination as! UINavigationController
    let playVC = nav.viewControllers.first as! PlayViewController
    playVC.playURL = capturePathURL
    playVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(dismissAction))
  }
  
  func showPlayerViewController() {
    let playerVC = MPMoviePlayerViewController(contentURL: capturePathURL)!
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
  
  @IBAction private func playAction(_ sender: UIBarButtonItem) {
    showPlayerViewController()
  }
  
  @objc private func dismissAction() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func startOrStop(_ sender: UIButton) {
    isCapturing = !isCapturing
    if isCapturing {
      movieFileOutput.startRecording(toOutputFileURL: capturePathURL, recordingDelegate: self)
    } else {
      movieFileOutput.stopRecording()
    }
  }
  
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate {
  
  func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
    print(captureOutput.recordedFileSize)
    showPlayerViewController()
  }
  
}
