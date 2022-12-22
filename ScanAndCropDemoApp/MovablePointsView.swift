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

class ImageCropperView1: UIView {
    let imageView = UIImageView()
    let topLeftPoint = UIView()
    let topRightPoint = UIView()
    let bottomLeftPoint = UIView()
    let bottomRightPoint = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the image view and points as subviews
        addSubview(imageView)
        addSubview(topLeftPoint)
        addSubview(topRightPoint)
        addSubview(bottomLeftPoint)
        addSubview(bottomRightPoint)
        
        // Add pan gesture recognizers to the points
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        topLeftPoint.addGestureRecognizer(panGestureRecognizer)
        topRightPoint.addGestureRecognizer(panGestureRecognizer)
        bottomLeftPoint.addGestureRecognizer(panGestureRecognizer)
        bottomRightPoint.addGestureRecognizer(panGestureRecognizer)
        
        // Set up the points with constraints
        topLeftPoint.translatesAutoresizingMaskIntoConstraints = false
        topRightPoint.translatesAutoresizingMaskIntoConstraints = false
        bottomLeftPoint.translatesAutoresizingMaskIntoConstraints = false
        bottomRightPoint.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLeftPoint.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            topLeftPoint.topAnchor.constraint(equalTo: imageView.topAnchor),
            topRightPoint.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            topRightPoint.topAnchor.constraint(equalTo: imageView.topAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        // Get the current location of the gesture
        let location = gestureRecognizer.location(in: self)

        // Update the position of the point that the gesture was detected on
        if gestureRecognizer.view == topLeftPoint {
            topLeftPoint.center = location
        } else if gestureRecognizer.view == topRightPoint {
            topRightPoint.center = location
        } else if gestureRecognizer.view == bottomLeftPoint {
            bottomLeftPoint.center = location
        } else if gestureRecognizer.view == bottomRightPoint {
            bottomRightPoint.center = location
        }

        // Update the frame of the image view based on the new positions of the points
        let x = min(topLeftPoint.center.x, bottomLeftPoint.center.x)
        let y = min(topLeftPoint.center.y, topRightPoint.center.y)
        let width = max(topRightPoint.center.x, bottomRightPoint.center.x) - x
        let height = max(bottomLeftPoint.center.y, bottomRightPoint.center.y) - y
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
}

class ImageCropperView: UIView {
    var topLeftHandle = CGPoint.zero
    var topRightHandle = CGPoint.zero
    var bottomLeftHandle = CGPoint.zero
    var bottomRightHandle = CGPoint.zero
    var topMiddleHandle = CGPoint.zero
    var bottomMiddleHandle = CGPoint.zero

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()

        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(2.0)

        // Draw cropping lines
        context?.move(to: topLeftHandle)
        context?.addLine(to: topRightHandle)
        context?.addLine(to: bottomRightHandle)
        context?.addLine(to: bottomLeftHandle)
        context?.addLine(to: topLeftHandle)
        context?.move(to: topMiddleHandle)
        context?.addLine(to: bottomMiddleHandle)
        context?.strokePath()

        // Draw handles
        let handleSize: CGFloat = 10.0
        context?.fill(CGRect(x: topLeftHandle.x - handleSize / 2, y: topLeftHandle.y - handleSize / 2, width: handleSize, height: handleSize))
        context?.fill(CGRect(x: topRightHandle.x - handleSize / 2, y: topRightHandle.y - handleSize / 2, width: handleSize, height: handleSize))
        context?.fill(CGRect(x: bottomLeftHandle.x - handleSize / 2, y: bottomLeftHandle.y - handleSize / 2, width: handleSize, height: handleSize))
        context?.fill(CGRect(x: bottomRightHandle.x - handleSize / 2, y: bottomRightHandle.y - handleSize / 2, width: handleSize, height: handleSize))
        context?.fill(CGRect(x: topMiddleHandle.x - handleSize / 2, y: topMiddleHandle.y - handleSize / 2, width: handleSize, height: handleSize))
        context?.fill(CGRect(x: bottomMiddleHandle.x - handleSize / 2, y: bottomMiddleHandle.y - handleSize / 2, width: handleSize, height: handleSize))
    }
}

class ViewWithDottedLine: UIView {
    let firstView: UIView
    let secondView: UIView
    let shapeLayer = CAShapeLayer()

    init(firstView: UIView, secondView: UIView) {
        self.firstView = firstView
        self.secondView = secondView
        super.init(frame: .zero)

        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [4, 4]
        layer.addSublayer(shapeLayer)
        
        // Add target to the gesture recognizers
               let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        firstView.addGestureRecognizer(panGestureRecognizer1)
               let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        secondView.addGestureRecognizer(panGestureRecognizer2)
    }

    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
           // Update the path of the CAShapeLayer object
           updateShapeLayerPath()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateShapeLayerPath() {
            let path = UIBezierPath()
            path.move(to: firstView.center)
            path.addLine(to: secondView.center)
            shapeLayer.path = path.cgPath
        }
    
}
class DottedLineView1: UIView {
    var view1: UIView
    var view2: UIView
    var view3: UIView
    var view4: UIView

    init(view1: UIView, view2: UIView, view3: UIView, view4: UIView) {
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.move(to: view1.center)
        path.addLine(to: view2.center)
        path.addLine(to: view3.center)
        path.addLine(to: view4.center)
        path.close()

        let dashes: [CGFloat] = [path.lineWidth, path.lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = .butt
        UIColor.black.setStroke()
        path.stroke()
    }
}


class SquareView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineDash(phase: 0, lengths: [4, 4])

        // Draw lines connecting the four views
        let view1 = self.subviews[0]
        let view2 = self.subviews[1]
        let view3 = self.subviews[2]
        let view4 = self.subviews[3]
        context.move(to: view1.center)
        context.addLine(to: view2.center)
        context.addLine(to: view3.center)
        context.addLine(to: view4.center)
        context.addLine(to: view1.center)
        context.strokePath()
    }
}
