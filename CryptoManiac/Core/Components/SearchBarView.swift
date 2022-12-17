//
//  SearchBarView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/17/22.
//

import SwiftUI

struct SearchBarView: View {
    //MARK:   PROPERTIES
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty  ?
                                 Color.theme.secondaryText  :  Color.theme.accent
            )
            
            //MARK:  SEARCH BAR TEXT FIELD
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .autocorrectionDisabled(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()//this padding expands the tappable surface area for the user UI
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty  ?  0.0  :  1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing( )
                            searchText = ""
                        }
                    
                    
                    , alignment: .trailing
                  )
          
                 }
                    .font(.headline)
                    .padding( )
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.background)
                        .shadow(
                            color:  Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
                    )
                    .padding( )
    }
     
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
