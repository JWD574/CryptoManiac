//
//  CoinImageService.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/16/22.
//

import Foundation
import SwiftUI
import Combine


class CoinImageService {
    
    @Published var image:  UIImage? = nil
    
    private var imageSubscription:  AnyCancellable?
    private let coin: Coin
   
    init(coin:  Coin) {
        self.coin = coin
                getCoinImage( )
       
            }
    
        private func getCoinImage() {
            guard let url = URL(string: coin.image) else {
                return
                
            }
       
               imageSubscription = NetworkingManager.download(url: url)
                .tryMap({ (data) -> UIImage?  in
                    return UIImage(data: data)
                })
                 .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue:  { [weak self] (returnedImage) in
                     self?.image = returnedImage
                     self?.imageSubscription?.cancel( )
                 })
        }
}
