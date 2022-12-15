//
//  CircleButtonAnimationView.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/14/22.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    //MARK:  PROPERTIES
    @Binding var animate:  Bool
    
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0  :  0.0)
            .opacity(animate  ? 0.0  :  1.0)
            .animation(animate  ?    Animation.easeOut(duration: 1.0)  :   .none)
            
    }
}
struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
