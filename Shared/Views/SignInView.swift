//
//  SignInView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct SignInView: View {    
    @State private var text: String = ""
    @State private var signingIn: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                TextField(
                    "Enter OpenSea ETH address",
                    text: $text
                )
                
                Button("Start slideshow") {
                    print("Button tapped")
                    signingIn = true
                    OpenSeaAPI.fetchAssets(for: text) { error in
                        signingIn = false
                        print("In the result")
                    }
                }
                .disabled(self.text == "" || signingIn)
            })
            
            if signingIn {
                ActivityView()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
