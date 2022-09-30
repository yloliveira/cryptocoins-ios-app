//
//  ViewController.swift
//  cryptocoins
//
//  Created by Yan Oliveira on 29/09/22.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var coinManager = CoinManager()
    var coin: String?
    var currency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coin = coinManager.coinsArray[0]
        currency = coinManager.currenciesArray[0]
        coinManager.fetchCoinValueBy(coin: coin!, currency: currency!)
    }
    
    func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}

//MARK: - UIPickerViewDataSource

extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return coinManager.coinsArray.count
        }
        return coinManager.currenciesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return coinManager.coinsArray[row]
        }
        return coinManager.currenciesArray[row]
    }
}

//MARK: - UIPickerViewDelegate

extension HomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        startLoading()
        
        if component == 0 {
            self.coin = coinManager.coinsArray[row]
        } else {
            self.currency = coinManager.currenciesArray[row]
        }
        
        coinManager.fetchCoinValueBy(coin: coin!, currency: currency!)
    }
}

//MARK: - CoinManagerDelegate

extension HomeViewController: CoinManagerDelegate {
    func coinManagerDidFetchExchangeRateData(_ coinManager: CoinManager, _ coinExchangeRate: CoinExchangeRate) {
        DispatchQueue.main.async {
            self.resultLabel.text = coinExchangeRate.rateString
            self.coinNameLabel.text = coinExchangeRate.coin
            self.stopLoading()
        }
    }
    
    func coinManagerDidFailWithError(_ error: Error) {
        stopLoading()
    }
}
