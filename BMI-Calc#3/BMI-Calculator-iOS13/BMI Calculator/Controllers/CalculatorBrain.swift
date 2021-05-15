//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Sabir Myrzaev on 10.05.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    var bmi: BMI?
    
    func getBMIValue() -> String{
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiTo1DecimalPlace
    }
    
    func getAdvice() -> String{
        let adviceChallenge = String(bmi?.advice ?? "default number")
        return adviceChallenge
    }
    
    func getColor() -> UIColor{
        let colorChallenge = bmi?.color ?? UIColor.white
        return colorChallenge
    }
    

    mutating func calculateBrain(height: Float, weight: Float) {
        let bmiValue = weight / pow(height, 2)
            if bmiValue < 18.5 {
                bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
            } else if bmiValue < 24.9{
                bmi = BMI(value: bmiValue, advice: "Fir as a fiddle!", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            } else {
                bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        }
    }
}
