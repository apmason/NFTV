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
    @Namespace var AccountViewSpace
    
    var body: some View {
        if model.showSettings {
            SettingsView()
                .transition(.opacity)
        }
        else if let asset = model.activeAsset {
            withAnimation {
                FullAssetView(asset: asset, useSlideshow: model.slideshowActive)
                    .transition(.opacity)
            }
        }
        else {
            VStack(alignment: .leading, spacing: 10) {
                AccountDetailView(accountInfo: account.accountInfo, namespace: AccountViewSpace)
                    .focusScope(AccountViewSpace)
                Divider()
                Button("Start Slideshow") {
                    model.beginSlideshow()
                }
                .prefersDefaultFocus(in: AccountViewSpace)
                .disabled(account.assets.count == 0)
                .padding()
                AssetOverviewView(assets: account.assets)
            }
            #if os(tvOS)
            .focusScope(AccountViewSpace)
            #endif
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: OpenSeaAccount(address: "0x123456789123456789", username: nil))
    }
}
