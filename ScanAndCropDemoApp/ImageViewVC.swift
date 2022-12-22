//
//  ImageViewVC.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 22/12/22.
//

import UIKit

class ImageViewVC: UIViewController {

    var img = UIImage()
    @IBOutlet weak var croppedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        croppedImage.image = img
    }


}
