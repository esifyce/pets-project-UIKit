//
//  SecondViewController.swift
//  GCD
//
//  Created by Sabir Myrzaev on 15.06.2021.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
    
    // MARK: - Добавляем задержку
    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    // MARK: - AlertController
    fileprivate func loginAlert() {
        let ac = UIAlertController(title: "Зарегестрирован?", message: "Введите ваш логин и пароль", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        ac.addTextField { usernameTF in
            usernameTF.placeholder = "Введите логин"
        }
        
        ac.addTextField { userPasswordTF in
            userPasswordTF.placeholder = "Введите пароль"
            userPasswordTF.isSecureTextEntry = true
        }
        
        present(ac, animated: true, completion: nil)
    }
    // MARK: - LoadImage
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
        // убеждаемся что адресс работает, проверяем можем ли мы получить данные
        guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
        DispatchQueue.main.async {
            self.image = UIImage(data: imageData)
            }
        }
    }
}
