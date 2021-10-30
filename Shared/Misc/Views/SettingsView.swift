//
//  SettingsView.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            Button {
                OpenSeaModel.shared.endSlideshow()
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
            
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
