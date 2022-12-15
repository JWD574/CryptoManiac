//
//  CryptoManiacApp.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import SwiftUI

@main
struct CryptoManiacApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
