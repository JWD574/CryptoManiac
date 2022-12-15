//
//  String.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
