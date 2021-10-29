//
//  AccountView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var model = OpenSeaModel.shared
    @ObservedObject var account: OpenSeaAccount
    
    var body: some View {
        if let asset = model.activeAsset {
            FullAssetView(asset: asset)
                .transition(.opacity)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                AccountDetailView(accountInfo: account.accountInfo)
                Divider()
                Button("Start Slideshow") {
                    print("Start")
                    model.beginSlideshow()
                }
                .disabled(account.assets.count == 0)
                .padding()
                AssetOverviewView(assets: account.assets)
                    .padding()
            }
            .focusSection()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: OpenSeaAccount(address: "0x123456789123456789", username: nil))
    }
}
