//
//  Utils.swift
//  Warranty Tracker
//
//  Created by Adam Mierov on 02/06/2021.
//

import Foundation
import UIKit


class Utils {

    
    func shakeView(viewToShake:UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))

        viewToShake.layer.add(animation, forKey: "position")
    }
    
    func setTextFieldSideIcon(image: UIImage, textField: UITextField) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 40))
        iconContainerView.addSubview(iconView)
        
        textField.tintColor = UIColor.lightGray
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
    }
    
    func roundButtonCorneres(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
    }

    
    func roundedButton(button : UIButton){
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func useUnderline(textField: UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(2.0) // Border Width
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :textField.frame.size.height - borderWidth), size: CGSize(width: textField.frame.size.width, height: textField.frame.size.height))
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func addTextFieldShadow(textField: UITextField) {
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 4.0
    }
    
    func dateToInt(someDate:Date) -> Int {
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970

        // convert to Integer
        return Int(timeInterval)
    }
    
    func intToDate(interval:Int) -> Date {
        // convert Int to TimeInterval (typealias for Double)
        let timeInterval = TimeInterval(interval)

        // create NSDate from Double (NSTimeInterval)
        return Date(timeIntervalSince1970: timeInterval)
    }
}
