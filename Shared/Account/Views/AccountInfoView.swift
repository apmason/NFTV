//
//  AccountInfoView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct AccountInfoView: View {
    
    let accountInfo: AccountInfo
    
    var body: some View {
        HStack {
            AccountImageView()
            AccountTextStack(username: accountInfo.username ?? "Unnamed",
                             address: accountInfo.address)
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoView(accountInfo: AccountInfo(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                             username: "zeent",
                                             accountURL: nil))
    }
}