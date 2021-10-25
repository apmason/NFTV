//
//  SignInView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct LoginError {
    var error: Error?
    var shouldAlert: Bool
    
    init(error: Error? = nil) {
        self.error = error
        self.shouldAlert = error != nil
    }
}

struct SignInView: View {    
    @State private var text: String = ""
    @State private var signingIn: Bool = false
    
    @State private var errorTracker: LoginError = LoginError()
    
    var body: some View {
        ZStack {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                TextField(
                    "Enter OpenSea ETH address",
                    text: $text
                )
                
                Button("Start slideshow") {
                    signingIn = true // Show activity indicator
                    OpenSeaAPI.fetchAssets(for: text) { error in
                        signingIn = false
                        errorTracker = LoginError(error: error)
                    }
                }
                .disabled(self.text == "" || signingIn)
            })
            .alert(isPresented: $errorTracker.shouldAlert) {
                // we should clear out the text field
                var messageText: Text? = nil
                if let error = errorTracker.error {
                    messageText = Text("\(error.localizedDescription)")
                }
                
                return Alert(title: Text("Error"), message: messageText, dismissButton: nil)
            }
            
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
