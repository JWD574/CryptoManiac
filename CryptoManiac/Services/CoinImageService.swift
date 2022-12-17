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
    //MARK:  PROPERTIES
    @Published var image:  UIImage? = nil
    
    private var imageSubscription:  AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin:  Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage( )  {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrieved image from File Manager!")
        }else {
            downloadCoinImage()
            print("Downloading image...")
        }
        
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else {return}
            
            imageSubscription = NetworkingManager.download(url: url)
                .tryMap({ (data) -> UIImage?  in
                    return UIImage(data:  data)
                })
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue:  { [weak self] (returnedImage) in
                    guard let self = self, let downloadedImage = returnedImage  else {return}
                    self.image = downloadedImage
                    self.imageSubscription?.cancel( )
                    self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                })
        }
    }

