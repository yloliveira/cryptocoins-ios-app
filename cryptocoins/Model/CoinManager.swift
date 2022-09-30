//
//  CoinManager.swift
//  cryptocoins
//
//  Created by Yan Oliveira on 30/09/22.
//

import Foundation

struct CoinManager {
    private let COINAPI_KEY = Bundle.main.infoDictionary?["COINAPI_KEY"] as! String
    private let COINAPI_BASE_URL = "https://rest.coinapi.io/v1/exchangerate"
    let currenciesArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fetchCoinValueBy(currency: String) {
        let url = "\(COINAPI_BASE_URL)/BTC/\(currency)?apikey=\(COINAPI_KEY)"
        performRequest(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if data != nil {
                print(data!)
            }
        }
    }
    
    private func performRequest(with urlString: String, completionHandler handler:  @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: handler)
            task.resume()
        }
    }
}