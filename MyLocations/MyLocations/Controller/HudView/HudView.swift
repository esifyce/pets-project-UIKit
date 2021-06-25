//
//  HudView.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 20.06.2021.
//

import UIKit

class HudView: UIView {
    
    var text = ""
    
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        // Если установить isUserInteractionEnabled значение false, представление воспринимает любые прикосновения,
        // и все базовые представления перестают отвечать
        view.isUserInteractionEnabled = false
        
        hudView.show(animated: animated)
        return hudView
    }
    // draw() Метод вызывается всякий раз, когда UIKit хочет ваш взгляд перерисовать себя
    override func draw(_ rect: CGRect) {
        
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
                             y: ((bounds.size.height - boxWidth) / 2),
                             width: boxWidth,
                             height: boxHeight)
        // прямоугольник не попадает на границы дробных пикселей, потому что это делает изображение нечетким
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        // вычисляет положение для этого изображения на основе центральной координаты вида HUD
        guard let image = UIImage(named: "Checkmark") else { return }
        let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                 y: center.y - round(image.size.height / 2) - boxHeight / 8)
        image.draw(at: imagePoint)
        // рисуем текст
        let attribs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: attribs)
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                                y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    func show(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func hide(animated: Bool) {
            if animated {
                transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.7, initialSpringVelocity: 1.5, options: [], animations: {
                    self.alpha = 0
                    self.transform = CGAffineTransform.identity
                    self.superview?.isUserInteractionEnabled = true
                    afterDelay(0.6) {
                        self.removeFromSuperview()
                    }
                }, completion: nil)
            }
    }
}

