//
//  HomeView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import SwiftUI

struct HomeView: View {
    //MARK:  PROPERTIES
    @State private var showPortfolio:  Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            //MARK:  CONTENT LAYER
            VStack {
                //MARK:  HEADER AREA WITH CIRCLE BUTTONS
                homeHeader
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
}
