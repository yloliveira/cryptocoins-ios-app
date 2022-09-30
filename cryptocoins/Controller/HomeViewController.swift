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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinManager.fetchCoinValueBy(currency: coinManager.currenciesArray[0])
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currenciesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currenciesArray[row]
    }
}

//MARK: - UIPickerViewDelegate

extension HomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        startLoading()
        coinManager.fetchCoinValueBy(currency: coinManager.currenciesArray[row])
    }
}

//MARK: - CoinManagerDelegate

extension HomeViewController: CoinManagerDelegate {
    func coinManagerDidFetchExchangeRateData(_ coinManager: CoinManager, _ coinExchangeRate: CoinExchangeRate) {
        DispatchQueue.main.async {
            self.resultLabel.text = coinExchangeRate.rateString
            self.stopLoading()
        }
    }
    
    func coinManagerDidFailWithError(_ error: Error) {
        stopLoading()
    }
}
