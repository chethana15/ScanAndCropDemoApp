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

    @IBOutlet weak var imageAfterAlteration: UIImageView!
    var images = [UIImage]()
    var pdfDocument = PDFDocument()
    override func viewDidLoad() {
        super.viewDidLoad()
        let point1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let point2 = UIView(frame: CGRect(x: 90, y: 0, width: 10, height: 10))
        let point3 = UIView(frame: CGRect(x: 90, y: 90, width: 10, height: 10))
        let point4 = UIView(frame: CGRect(x: 0, y: 90, width: 10, height: 10))
        let point5 = UIView(frame: CGRect(x: 45, y: 0, width: 10, height: 10))
        let point6 = UIView(frame: CGRect(x: 45, y: 90, width: 10, height: 10))

        imageAfterAlteration.addSubview(point1)
        imageAfterAlteration.addSubview(point2)
        imageAfterAlteration.addSubview(point3)
        imageAfterAlteration.addSubview(point4)
        imageAfterAlteration.addSubview(point5)
        imageAfterAlteration.addSubview(point6)
        imageAfterAlteration.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageAfterAlteration.addGestureRecognizer(tapGestureRecognizer)
    }


    @objc func imageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: imageAfterAlteration)
        let imagePoint = imageAfterAlteration.convert(point, to: imageAfterAlteration.image as! UICoordinateSpace)

    }


    @IBAction func startCaptureTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
//        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
//        let imageToBeCropped = image

        let point1 = CGPoint(x: 100, y: 100)
        let point2 = CGPoint(x: 200, y: 100)
        let point3 = CGPoint(x: 200, y: 200)
        let point4 = CGPoint(x: 100, y: 200)
        
        let minX = min(point1.x, point2.x, point3.x, point4.x)
        let minY = min(point1.y, point2.y, point3.y, point4.y)
        let maxX = max(point1.x, point2.x, point3.x, point4.x)
        let maxY = max(point1.y, point2.y, point3.y, point4.y)
        
        let cropRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        let croppedCGImage = image.cgImage!.cropping(to: cropRect)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        imageAfterAlteration.image = croppedImage
        
    }
    
    @IBAction func savePDF(_ sender: Any) {
        let pdf = createPDFDataFromImage(image: imageAfterAlteration.image!)
        guard let path = Bundle.main.url(forResource: "example", withExtension: "pdf") else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PdfVC") as! PdfVC
        if let document = PDFDocument(url: path) {
            vc.pdfView.document = document
        }
        present(vc, animated: true)
        
        }
    
    func createPDFDataFromImage(image: UIImage) -> NSMutableData {
        let pdfData = NSMutableData()
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()

        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("file.pdf")

        do {
                try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("error catched")
        }

        return pdfData
    }
    
}

