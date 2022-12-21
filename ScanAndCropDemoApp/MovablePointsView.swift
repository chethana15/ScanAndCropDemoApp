//
//  MovablePointsView.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 19/12/22.
//

import UIKit
class MovablePoint: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
