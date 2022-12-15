//
//  ContentView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack{
                
                Text(" Accent Color ")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
