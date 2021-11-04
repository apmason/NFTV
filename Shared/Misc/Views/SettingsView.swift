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
        VStack(alignment: .leading, spacing: 20) {
            Button {
                OpenSeaModel.shared.exitSettings()
            } label: {
                Image(systemName: "xmark")
            }
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.regular)
            
            Divider()
            
            Button("Change OpenSea Account") {
                OpenSeaModel.shared.signOutAccount()
            }
            
            HStack {
                Text("Seconds per slide: ")
                TextField("", text: $secondsPerSlide, prompt: nil)
                    .frame(maxWidth: 175)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        guard let newSecondsPerSlide = Int(secondsPerSlide) else {
                            return
                        }
                        
                        OpenSeaModel.shared.secondsPerSlide = newSecondsPerSlide
                    }
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
