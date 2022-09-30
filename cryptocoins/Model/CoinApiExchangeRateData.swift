//
//  CoinApiExchangeRateData.swift
//  cryptocoins
//
//  Created by Yan Oliveira on 30/09/22.
//

struct CoinApiExchangeRateData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
