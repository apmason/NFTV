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
    @State private var cryptoAddress: String = ""
    @State private var signingIn: Bool = false
    
    @State private var errorTracker: LoginError = LoginError()
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                GeometryReader { geo in
                    Text("NFTV")
                        .font(.system(size: 220))
                        .fontWeight(.black)
                        .position(x: geo.size.width / 4, y: geo.size.height / 2)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                    
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        TextField(
                            "Enter OpenSea address (e.g., 0x6bff...44cd)",
                            text: $cryptoAddress
                        )
                        
                        Button("View NFTs") {
                            signingIn = true // Show activity indicator
                            OpenSeaModel.shared.attemptSignIn(for: cryptoAddress) { error in
                                signingIn = false
                                guard let error = error else {
                                    return
                                }
                                
                                errorTracker = LoginError(error: error)
                            }
                        }
                        .disabled(self.cryptoAddress == "" || signingIn)
                    })
                        .position(x: (geo.size.width / 4) * 3, y: geo.size.height / 2)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alert(isPresented: $errorTracker.shouldAlert) {
                    // we should clear out the text field
                    var messageText: Text? = nil
                    if let error = errorTracker.error {
                        messageText = Text("\(error.localizedDescription)")
                    }
                    
                    return Alert(title: Text("Error"), message: messageText, dismissButton: nil)
                }
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
