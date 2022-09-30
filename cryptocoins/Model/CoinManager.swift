//
//  CoinManager.swift
//  cryptocoins
//
//  Created by Yan Oliveira on 30/09/22.
//

import Foundation

protocol CoinManagerDelegate {
    func coinManagerDidFetchExchangeRateData(_ coinManager: CoinManager, _ coinExchangeRate: CoinExchangeRate) -> Void
    func coinManagerDidFailWithError(_ error: Error) -> Void
}

struct CoinManager {
    private let COINAPI_KEY = Bundle.main.infoDictionary?["COINAPI_KEY"] as! String
    private let COINAPI_BASE_URL = "https://rest.coinapi.io/v1/exchangerate"
    let currenciesArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?
    
    func fetchCoinValueBy(currency: String) {
        let url = "\(COINAPI_BASE_URL)/BTC/\(currency)?apikey=\(COINAPI_KEY)"
        performRequest(with: url) { (data, response, error) in
            if error != nil {
                delegate?.coinManagerDidFailWithError(error!)
                return
            }
            if let safeData = data {
                if let decodedData = self.parseJSON(safeData) {
                    let exchangeRate = CoinExchangeRate(rate: decodedData.rate, currency: decodedData.asset_id_quote, coin: decodedData.asset_id_base)
                    delegate?.coinManagerDidFetchExchangeRateData(self, exchangeRate)
                }
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
    
    private func parseJSON(_ data: Data) -> CoinApiExchangeRateData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinApiExchangeRateData.self, from: data)
            return decodedData
        } catch {
            delegate?.coinManagerDidFailWithError(error)
            return nil
        }
    }
}
