//
//  circleView.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 22/12/22.
//

import Foundation
import UIKit

extension UIView{
    
    public func makeCircleView(view: UIView){
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
