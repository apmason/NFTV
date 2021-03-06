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
        VStack(alignment: .leading, spacing: 10) {
            AccountDetailView(accountInfo: account.accountInfo, namespace: AccountViewSpace)
                #if os(tvOS)
                .focusScope(AccountViewSpace)
                #endif
            Divider()
            
            HStack {
                NavigationLink {
                    SlideshowView()
                } label: {
                    Text("Start Slideshow")
                }
                
                #if os(tvOS)
                .prefersDefaultFocus(in: AccountViewSpace)
                #endif
                
                Spacer()
                
                NavigationLink("Settings") {
                    SettingsView()
                }
                
                #if os(tvOS)
                .prefersDefaultFocus(false, in: AccountViewSpace)
                #endif
            }
            .padding()
            
            AssetOverviewView(assets: account.assets)
                #if os(tvOS)
                .focusSection()
                #endif
        }
        #if os(tvOS)
        .focusScope(AccountViewSpace)
        #endif
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: OpenSeaAccount(address: "0x123456789123456789", username: nil))
    }
}
