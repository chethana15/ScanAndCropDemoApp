//
//  ViewController.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 17/12/22.
//

import UIKit
import CoreImage
import PDFKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet var panGestureRecogniser1: UIPanGestureRecognizer!
    @IBOutlet var panGestureRecogniser2: UIPanGestureRecognizer!
    @IBOutlet var panGestureRecogniser3: UIPanGestureRecognizer!
    @IBOutlet weak var imageAfterAlteration: UIImageView!
    @IBOutlet var panGestureRecogniser4: UIPanGestureRecognizer!
    let shapeLayer = CAShapeLayer()
    var pdfDocument = PDFDocument()
    var x1 = Double()
    var y1 = Double()
    var x2 = Double()
    var y2 = Double()
    var x3 = Double()
    var y3 = Double()
    var x4 = Double()
    var y4 = Double()
    let path = UIBezierPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.backgroundColor = .red
        view2.backgroundColor = .red
        view3.backgroundColor = .red
        view4.backgroundColor = .red
        view1.makeCircleView(view: view1)
        view2.makeCircleView(view: view2)
        view3.makeCircleView(view: view3)
        view4.makeCircleView(view: view4)


        let view1Center = view1.center
        x1 = view1Center.x
        y1 = view1Center.y
        print("....x:\(x1)...y:\(y1)")
        let view2Center = view2.center
        x2 = view2Center.x
        y2 = view2Center.y
        print("....x:\(x2)...y:\(y2)")
        
        let view3Center = view3.center
        x3 = view3Center.x
        y3 = view3Center.y
        print("....x:\(x3)...y:\(y3)")
        let view4Center = view4.center
        x4 = view4Center.x
        y4 = view4Center.y
        print("....x:\(x4)...y:\(y4)")

        path.move(to: view1.center)
        path.addLine(to: view2.center)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 4.0
        transparentView.layer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.lineDashPattern = [5, 5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        transparentView.layer.addSublayer(shapeLayer)
        updateShapeLayerPath()

    }
    override func viewWillAppear(_ animated: Bool) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.addLine(to: CGPoint(x: x3, y: y3))
        path.addLine(to: CGPoint(x: x4, y: y4))

        path.close()
    }
    func updateShapeLayerPath() {
        let path = UIBezierPath()
        path.move(to: view1.center)
        path.addLine(to: view2.center)
        path.addLine(to: view4.center)
        path.addLine(to: view3.center)
        path.addLine(to: view1.center)
        
        // Set the path of the shape layer
        shapeLayer.path = path.cgPath
    }

    
    
    @IBAction func startCaptureTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        //        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func savePDF(_ sender: Any) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
               let point1 = CGPoint(x: x1, y: y1)
               let point2 = CGPoint(x: x2, y: y2)
               let point4 = CGPoint(x: x3, y: y3)
               let point3 = CGPoint(x: x4, y: y4)
               
               let minX = min(point1.x, point2.x, point3.x, point4.x)
               let minY = min(point1.y, point2.y, point3.y, point4.y)
               let maxX = max(point1.x, point2.x, point3.x, point4.x)
               let maxY = max(point1.y, point2.y, point3.y, point4.y)
               
               let rectToCrop = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        let croppedImage: UIImage
//               let croppedCGImage = image.cgImage!.cropping(to: cropRect)
//               let croppedImage = UIImage(cgImage: croppedCGImage!)
               
        let factor = imageAfterAlteration.frame.width/image.size.width
        let rect = CGRect(x: rectToCrop.origin.x / factor, y: rectToCrop.origin.y / factor, width: rectToCrop.width / factor, height: rectToCrop.height / factor)
        croppedImage = cropImage1(image: image, rect: rect)


               imageAfterAlteration.image = image
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
        vc.img = croppedImage
        present(vc, animated: true)
        
    }
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
    }

    func cropImage2(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    @IBAction func panGesture1Dragged(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            let changeY = (sender.view?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            print("x1:\(changeX), y1:\(changeY)")
            x1 = changeX
            y1 = changeY
            sender.setTranslation(CGPoint.zero, in: sender.view)
            updateShapeLayerPath()
            
        }
    }
    
    @IBAction func panGesture2Dragged(_ sender: UIPanGestureRecognizer) {
//        shapeLayer.removeFromSuperlayer()
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            let changeY = (sender.view?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            print("x2:\(changeX), y2:\(changeY)")

            x2 = changeX
            y2 = changeY
            sender.setTranslation(CGPoint.zero, in: sender.view)

            updateShapeLayerPath()
        }
    }
    
    @IBAction func panGesture3Dragged(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            let changeY = (sender.view?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            print("x3:\(changeX), y3:\(changeY)")

            x3 = changeX
            y3 = changeY
            sender.setTranslation(CGPoint.zero, in: sender.view)
            updateShapeLayerPath()
        }
    }
    
    @IBAction func panGesture4Dragged(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            let changeY = (sender.view?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            print("x4:\(changeX), y4:\(changeY)")

            x4 = changeX
            y4 = changeY
            sender.setTranslation(CGPoint.zero, in: sender.view)
            updateShapeLayerPath()
        }
    }
    
}
