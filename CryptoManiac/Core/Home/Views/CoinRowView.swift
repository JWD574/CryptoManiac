//
//  CoinRowView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/15/22.
//

import SwiftUI

struct CoinRowView: View {
    //MARK:  PROPERTIES
    let coin: Coin
    let showHoldingsColumn:  Bool
    
    var body: some View {
        HStack {
            //MARK:  LEFT COLUMN
          leftColumn
            Spacer()
            if showHoldingsColumn {
                //MARK: CENTER COLUMN
                centerColumn
            }
       rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
extension CoinRowView {
    
    private var leftColumn:  some View {
        HStack(spacing: 0) {
            //coin rank
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(minWidth: 30, maxHeight: 30)
            //coin symbol
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
        
    }
    private var centerColumn:   some View {
        VStack (alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
            Text((coin.currentHoldings  ??  0).asNumberString( ))
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn:   some View {
        
        VStack (alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ??  "")
                .foregroundColor(
                    (coin.priceChangePercentage24H  ??  0) >= 0 ?
                    Color.theme.green  :
                        Color.theme.red
                )
        }
        //divides screen into three even segments or columns
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
}
