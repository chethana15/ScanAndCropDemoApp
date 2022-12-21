//
//  PdfVC.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 19/12/22.
//

import UIKit
import PDFKit

class PdfVC: UIViewController {

    let pdfView = PDFView()
    override func viewDidLoad() {
        super.viewDidLoad()
       

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }


}
