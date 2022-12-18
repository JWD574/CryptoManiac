//
//  HomeView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import SwiftUI
import Combine

struct HomeView: View {
    //MARK:  PROPERTIES
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio:  Bool = false
    
    var body: some View {
        ZStack {
            
            //MARK: BACKGROUND LAYER
            Color.theme.background
                .ignoresSafeArea()
            
            
            
                //MARK:  CONTENT LAYER
                VStack {
                //MARK:  HEADER AREA WITH CIRCLE BUTTONS
                homeHeader
                //MARK:  HOME STATS
                HomeStatsView(showPortfolio: $showPortfolio)
                //MARK: SEARCH BAR
                SearchBarView(searchText:$vm.searchText)
                //MARK:  LIST HEADER { COIN  - HOLDINGS - PRICE }
                columnTitles
                
                
                //MARK:  LIST OF ALL COINS
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                //MARK:  LIST OF ALL PORTFOLIO COINS
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
                
            }
        }
    }
    
}
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
                    .environmentObject(dev.homeVM)
            }
        }
    }
//MARK:   EXTENSIONS
extension HomeView {
    
    private var homeHeader:  some View {
        HStack {
            CircleButtonView(iconName:  showPortfolio  ?  "plus"  :  "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio  ?  "My Portfolio"  :  "Live Market Data")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees:  showPortfolio  ?  180 : 0))
                .onTapGesture {
                    withAnimation(.spring( )) {
                        showPortfolio.toggle( )
                    }
                }
        }
        .padding(.horizontal)
    }
    //ALL COINS LIST EXTRACTION
    private var allCoinsList:  some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    private var portfolioCoinsList:  some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles:  some View {
        //MARK:  LIST HEADER { COIN  - HOLDINGS - PRICE }
        HStack {
            
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Spacer()
            Text("Price")
            
        }
        .padding(.horizontal, 30)
        .font(.footnote)
        .foregroundColor(Color.theme.secondaryText)
    }
}
//MARK:  HOMEVIEW MODEL
class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = [ ]
    
    @Published var allCoins: [Coin] = [ ]
    @Published var portfolioCoins: [Coin] = [ ]
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService( )
    private let marketDataService = MarketDataService( )
    private var cancellables =  Set<AnyCancellable>( )
    
    
    init () {
        addSubscriber()
        //        DispatchQueue.main.asyncAfter(deadline: .now( )  + 2.0) {
        //            self.allCoins.append(DeveloperPreview.instance.coin)
        //            self.portfolioCoins.append(DeveloperPreview.instance.coin)
    }
    //MARK:  SUBSCRIBER FUNCTION (SEARCH BAR FILTER)
    
    func addSubscriber( ) {
        //UPDATES ALL COINS
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        //updates market data...
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins:  [Coin])  -> [Coin]  {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText)  ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel]  {
        var stats:  [StatisticModel] = [ ]
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        stats.append(marketCap)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value:  "$0.00", percentageChange: 0)
        
        stats.append(contentsOf:  [
        marketCap,
        volume,
        btcDominance,
        portfolio
        ])
        return stats
    }
}
