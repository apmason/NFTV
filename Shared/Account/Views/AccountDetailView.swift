//
//  AccountDetailView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct AccountDetailView: View {
    
    let accountInfo: AccountInfo
    
    var body: some View {
        HStack {
            AccountImageView(imageURL: accountInfo.accountURL)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            AccountTextStack(username: accountInfo.username ?? "Unnamed",
                             address: accountInfo.displayableAddress)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(accountInfo: AccountInfo(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                                   username: "zeent",
                                                   accountURL: nil))
    }
}
