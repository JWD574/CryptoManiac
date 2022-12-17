//
//  CoinImageView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/16/22.
//

import SwiftUI
import Combine
import Foundation



//MARK:   VIEWMODEL
class CoinImageViewModel:  ObservableObject {
    
    @Published var image:  UIImage?  =  nil
    @Published var isLoading:  Bool = false
    
    private let coin:  Coin
    private let dataService:  CoinImageService
    private var cancellables =   Set<AnyCancellable>( )
    
    init(coin: Coin )   {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers( ) {
        dataService.$image
            .sink {  [weak self] (_) in
                self?.isLoading = false
            } receiveValue: {  [weak self]  (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
//MARK:  COIN IMAGE VIEW
struct CoinImageView: View {
    //MARK:  PROPERTIES
      @StateObject var vm:  CoinImageViewModel
    
    init(coin:  Coin){
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
        
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable( )
                    .scaledToFit( )
            } else if vm.isLoading {
                ProgressView( )
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin )
            .padding( )
            .previewLayout(.sizeThatFits)
    }
}
