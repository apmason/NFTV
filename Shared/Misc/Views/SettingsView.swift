//
//  SettingsView.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import SwiftUI

struct SettingsView: View {
    @State var secondsPerSlide: String = "\(OpenSeaModel.shared.secondsPerSlide)"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {

            Text("Settings")
                .font(.title)
                .fontWeight(.regular)
            
            Divider()
            
            HStack {
                Text("Seconds per slide: ")
                TextField("", text: $secondsPerSlide, prompt: nil)
                    .frame(maxWidth: 175)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        guard let newSecondsPerSlide = Int(secondsPerSlide) else {
                            return
                        }
                        
                        OpenSeaModel.shared.secondsPerSlide = TimeInterval(newSecondsPerSlide)
                    }
            }
            
            Button("Change OpenSea Account") {
                OpenSeaModel.shared.signOutAccount()
            }
            
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
