//
//  ViewController.swift
//  FaceLandmarkDetection
//
//  Created by Krasivo on 19.08.2023.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    // MARK: - Propeprty
    
    var imageOrientation = CGImagePropertyOrientation(.up)
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let image = UIImage(named: "imageFriends") {
            imageView.image = image
            imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
            
            guard let cgImage = image.cgImage else { return }
            setupVision(image: cgImage)
        }
    }
}

private extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        addViews()
        addConstraints()
    }
    
    func addViews() {
        view.addSubview(imageView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }
    
    func setupVision(image: CGImage) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFaceDetectionRequest(request:error:))
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: imageOrientation, options: [:])
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch let error {
            print(error)
            return
        }
    }
    
    func handleFaceDetectionRequest(request: VNRequest?, error: Error?) {
        if let requestError = error as NSError? {
            print(requestError)
            return
        }
        DispatchQueue.main.async {
            guard
                let image = self.imageView.image,
                let cgImage = image.cgImage
            else { return }
            
            let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: self.imageView.frame)
            self.imageView.layer.sublayers = nil
            
            if let results = request?.results as? [VNFaceObservation] {
                results.forEach({ observation in
                    let faceRect = self.convertUnitToPoint(originalImageRect: imageRect, targetRect: observation.boundingBox)
                    
                    let emojiRect = CGRect(x: faceRect.origin.x,
                                           y: faceRect.origin.y - 5,
                                           width: faceRect.size.width + 5,
                                           height: faceRect.size.height + 5)
                    
                    let textLayer = CATextLayer()
                    textLayer.string = "🍑"
                    textLayer.fontSize = faceRect.width
                    textLayer.frame = emojiRect
                    textLayer.contentsScale = UIScreen.main.scale
                    
                    self.imageView.layer.addSublayer(textLayer)
                })
            }
        }
    }
}

