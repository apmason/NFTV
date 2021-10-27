//
//  AccountView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var account: OpenSeaAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AccountDetailView(accountInfo: account.accountInfo)
            Divider()
            Spacer()
            AssetOverviewView(assets: account.assets)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: OpenSeaAccount(address: "0x123456789123456789", username: nil))
    }
}
