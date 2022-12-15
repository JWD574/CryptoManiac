//
//  UIApplication.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
