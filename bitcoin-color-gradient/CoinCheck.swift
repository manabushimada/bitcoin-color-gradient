//
//  CoinCheck.swift
//  bitcoin-color-gradient
//
//  Created by Manabu Shimada on 05/08/2021.
//

import Foundation

struct CoinCheck: Codable {
    let ask: Int
//    let bit: Int
//    let high: Int
//    let last: Int
//    let low: Int
//    let timestamp: Int
//    let volume: String
    
    
    init(dict: NSDictionary) {
        self.ask = dict["ask"] as? Int ?? 0
    }
}
