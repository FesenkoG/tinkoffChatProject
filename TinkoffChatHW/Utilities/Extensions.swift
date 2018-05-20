//
//  Extensions.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 28.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
}


var timer: Timer?
//Создает логотипы тинькофф, выпрыгивающие из под пальца.
extension UIView {
    
    private var location: CGPoint {
        guard let recognizer = gestureRecognizers?.first(where: { (recognizer) -> Bool in
            return recognizer is UILongPressGestureRecognizer
        }) else { return CGPoint.zero}
        
        print(recognizer.location(in: self))
        return recognizer.location(in: self)
    }
    
    private var imgSize: CGFloat {
        return 40
    }
    
    func createTinkoffLogoAnimation() {
        let gestureRec = UILongPressGestureRecognizer(target: self, action: #selector(tapAccured(_:)))
        self.addGestureRecognizer(gestureRec)
    }

    
    @objc private func tapAccured(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateLogo), userInfo: nil, repeats: true)
            
        } else if gestureRecognizer.state == .ended {
            timer?.invalidate()
        } else if gestureRecognizer.state == .changed {
            //location = gestureRecognizer.location(in: self)
        }
    }
    
    @objc private func animateLogo() {
        let logoImg = UIImage(named: "logo")
        let logoImgView = UIImageView(image: logoImg)
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.alpha = 0
        logoImgView.frame = CGRect(x: location.x - imgSize/2, y: location.y - imgSize/2, width: imgSize, height: imgSize)
        self.insertSubview(logoImgView, aboveSubview: self)
        
        var x = CGFloat(arc4random_uniform(100))
        var y = CGFloat(arc4random_uniform(100))
        let sign = arc4random_uniform(4)
        switch sign {
        case 0:
            x = -x
        case 1:
            y = -y
        case 2:
            x = -x
            y = -y
        default:
            break
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn],animations: {
            
            
            logoImgView.center.x += x
            logoImgView.center.y += y
            logoImgView.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,animations: {
                logoImgView.alpha = 0
                logoImgView.center.x += x
                logoImgView.center.y += y
            }) { _ in
                logoImgView.removeFromSuperview()
            }
            
        }
        
    }
    
}

