//
//  ViewController.swift
//  bitcoin-color-gradient
//
//  Created by Manabu Shimada on 04/08/2021.
//

import UIKit

import Alamofire


class ViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var animatedGradientView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    
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
    var currentPrice = 0
    
    var coinCheck = [CoinCheck]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerStarted()
        getCoinCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientView.setupGradient()
        gradientView.animateGradient()
    }
    
    
    func bitCoinPriceChecked() {
        if currentPrice != updatedPrice {
            gradientView.randomColorChanged()
            priceLabelBigger()
            gradientView.blink()
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
    
    func priceLabelBigger() {
        self.priceLabel.transform = CGAffineTransform(scaleX: 2.1, y: 2.1)
        UIView.animate(withDuration: 1) {
            self.priceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
         }
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
    
    
   
    
}

