//
//  GradientView.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 02.07.2021.
//

import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    // draw transparent circle
    
    override func draw(_ rect: CGRect) {
        
        // 1 определяем используемый цвет
        let traints = UITraitCollection.current
        let color: CGFloat = traints.userInterfaceStyle == .light ? 0.314 : 1
        
        // 2 создаем 2 массива которые показывают как будет отображаться градиент
        let components: [CGFloat] = [
            color, color, color, 0.2,
            color, color, color, 0.4,
            color, color, color, 0.6,
            color, color, color, 1,
        ]
        let locations: [CGFloat] = [0, 0.5, 0.75, 1]
        
        // 3 с помощью остановок создаем градиент
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace,
                                  colorComponents: components,
                                  locations: locations,
                                  count: 4)
        // 4 координаты
        let x = bounds.midX
        let y = bounds.midY
        let centerPoint = CGPoint(x: x, y: y)
        let radius = max(x, y)
        
        // 5 получаем ссылку на контекст и далее рисуем
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!,
                                    startCenter: centerPoint,
                                    startRadius: 0,
                                    endCenter: centerPoint,
                                    endRadius: radius,
                                    options: .drawsAfterEndLocation)
    }
}
