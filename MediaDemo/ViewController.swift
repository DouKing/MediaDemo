//
//  ViewController.swift
//  MediaDemo
//
//  Created by iosci on 2017/3/1.
//  Copyright © 2017年 secoo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  lazy var imagePickerController: UIImagePickerController? = {
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      return nil
    }
    let available = UIImagePickerController.availableMediaTypes(for: .camera)
    guard let availableTypes = available else { return nil }
    if !availableTypes.contains(String(kUTTypeMovie)) {
      return nil
    }
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.mediaTypes = [String(kUTTypeMovie)]
    imagePickerController.videoQuality = .typeHigh
    imagePickerController.delegate = self
    return imagePickerController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if 0 == indexPath.row {
      guard let vc = self.imagePickerController else { return }
      self.present(vc, animated: true, completion: nil)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

}

