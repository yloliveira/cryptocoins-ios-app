//
//  CoinExchangeRate.swift
//  cryptocoins
//
//  Created by Yan Oliveira on 30/09/22.
//

struct CoinExchangeRate {
    var rate: Double
    var currency: String
    var coin: String
    var rateString: String {
        let rateStr = String(format: "%.2f", rate)
        return "\(rateStr) \(currency)"
    }
}
