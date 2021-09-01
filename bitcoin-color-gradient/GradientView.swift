//
//  GradientView.swift
//  bitcoin-color-gradient
//
//  Created by Manabu Shimada on 23/08/2021.
//

import UIKit

class GradientView: UIView {
    
    var color1: CGColor = UIColor(red: 1/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
    var color2: CGColor = UIColor(red: 1/255, green: 168/255, blue: 231/255, alpha: 1).cgColor
    var color3: CGColor = UIColor(red: 1/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
       // loadNib()
    }

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}

extension GradientView: CAAnimationDelegate {
    
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1) {
            self.alpha = 1.0
        }
    }
    
    
    //MARK:- Gradient
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
    
    func gradientUpdated() {
        gradientColorSet = [
            [color1, color2],
            [color2, color3],
            [color3, color1]
        ]
    }
    
    func updateColorIndex(){
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
    
    func randomColorChanged() {
        color1 = UIColor.rand.cgColor
        color2 = UIColor.rand.cgColor
        color3 = UIColor.rand.cgColor
        gradientUpdated()
    }

    
    
    func setupGradient(){
        gradientUpdated()
         
        gradient.frame = self.bounds
        gradient.colors = gradientColorSet[colorIndex]
        
        self.layer.addSublayer(gradient)
    }
    
    func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 3.0
        
        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradient.add(gradientAnimation, forKey: "colors")
    }
}
