//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 01.07.2021.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController, MenuViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var dismissStyle = AnimationStyle.fade
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    var downloadTask: URLSessionDownloadTask?
    var isPopUp = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
    }
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPopUp {
            popupView.layer.cornerRadius = 10
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            // Gradient view
            view.backgroundColor = UIColor.clear
            let dimmingView = GradientView(frame: CGRect.zero)
            dimmingView.frame = view.bounds
            view.insertSubview(dimmingView, at: 0)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPopover(_:)))
        }
        
        if searchResult != nil {
            updateUI()
        }
        
        if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            title = displayName
        }
    }
    
    // Cancel download if user close view
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    // MARK: - Actions
    
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Helper methods
    
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artist
        }
        kindLabel.text = searchResult.kind
        genreLabel.text = searchResult.genre
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        // Get image
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        popupView.isHidden = false
    }
    
    @objc func showPopover(_ sender: UIBarButtonItem) {
        guard let popover = storyboard?.instantiateViewController(withIdentifier: "PopoverView") as? MenuViewController else { return }
        popover.modalPresentationStyle = .popover
        if let ppc = popover.popoverPresentationController {
            ppc.barButtonItem = sender
        }
        popover.delegate = self
        present(popover, animated: true, completion: nil)
    }
    
    // MARK: - delegate
    
    func menuViewControllerSendEmail(_ controller: MenuViewController) {
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
            controller.setToRecipients(["myrzaev.qs@gmail.com"])
            self.present(controller, animated: true, completion: nil)
            controller.mailComposeDelegate = self
        }
    }
    
}

// MARK: - GestureRecognizer delegate

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return(touch.view === self.view)
    }
}

// MARK: - VC Transition delegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

// MARK: - MailCompose VC delegate
extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
