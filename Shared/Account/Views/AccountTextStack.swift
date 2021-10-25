//
//  AccountTextStack.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct AccountTextStack: View {
    
    let username: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(username)
                .font(.title)
                .fontWeight(.bold)
            Text(address)
                .font(.headline)
                .fontWeight(.regular)
        }
    }
}

struct AccountTextStack_Previews: PreviewProvider {
    static var previews: some View {
        AccountTextStack(username: "zander", address: "0x1234...5678")
    }
}
