//
//  ViewController.swift
//  bitcoin-color-gradient
//
//  Created by Manabu Shimada on 04/08/2021.
//

import UIKit

import Alamofire


class ViewController: UIViewController, CAAnimationDelegate {
    
    var color1: CGColor = UIColor(red: 1/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
    var color2: CGColor = UIColor(red: 1/255, green: 168/255, blue: 231/255, alpha: 1).cgColor
    var color3: CGColor = UIColor(red: 1/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0

    @IBOutlet weak var getBtcButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var animatedGradientView: UIView!
    
    
    let decoder: JSONDecoder = JSONDecoder()
    let urlString = "https://api.coindesk.com/v1/bpi/currentprice/BTC.json"
    let urlString2 = "https://coincheck.com/api/ticker"
    let method: HTTPMethod = .get
    let parameter = ["": ""]
    var coinDeskUsd: NSDictionary = ["": ""]
    let encoding: ParameterEncoding = URLEncoding.default
    
    var timer = Timer()
    var count = 0
    
    var updatedPrice = 0
    var currentPrice = 0 {
        didSet {
            if currentPrice != updatedPrice {
                print(currentPrice, updatedPrice)
            }
            
        }
    }
    
    var coinCheck = [CoinCheck]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timerStarted()
        getCoinCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupGradient()
        animateGradient()
    }
    
    
    func bitCoinPriceChecked() {
        if currentPrice != updatedPrice {
            priceLabelBigger()
            blink()
            randomColorChanged()
        }
        currentPrice = updatedPrice
    }
    
    
    func timerStarted() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.count += 1
            if ((self.count % 2) == 1) {
                self.getCoinCheck()
            }
        })
    }
    // MARK: - Actions
    
    @IBAction func updateCoinDeskButtonPressed(_ sender: UIButton) {
        getCoinCheck()
        randomColorChanged()
    }
    
    
    //MARK:- Alamofire
    private func getCoinCheck() {
        AF.request(urlString2, method: method, parameters: parameter).responseJSON { response in
            
            //print(response.result)
            
            do {
              let aDictionary : NSDictionary? = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                 
                let coinCheck_ = CoinCheck(dict: (aDictionary)!)
                //print(coinCheck_.ask)
                
                self.updatedPrice = coinCheck_.ask
                self.priceLabel.text = String(self.updatedPrice) + " $"
                self.bitCoinPriceChecked()
            } catch {
                print("failed")
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
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
    
    func blink() {
        self.animatedGradientView.alpha = 0.2
        UIView.animate(withDuration: 1) {
            self.animatedGradientView.alpha = 1.0
        }
    }
    
    func priceLabelBigger() {
        self.priceLabel.transform = CGAffineTransform(scaleX: 2.1, y: 2.1)
        UIView.animate(withDuration: 1) {
            self.priceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
         }
    }
    
    
    func setupGradient(){
        gradientUpdated()
         
        gradient.frame = self.animatedGradientView.bounds
        gradient.colors = gradientColorSet[colorIndex]
        
        self.animatedGradientView.layer.addSublayer(gradient)
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
}

