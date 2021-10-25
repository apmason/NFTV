//
//  AccountView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct AccountView: View {
    
    let account: OpenSeaAccount
    
    var body: some View {
        Text("Image go here")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: OpenSeaAccount(address: "0x123456789123456789", username: nil))
    }
}
