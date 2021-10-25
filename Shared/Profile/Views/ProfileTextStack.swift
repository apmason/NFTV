//
//  ProfileTextStack.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct ProfileTextStack: View {
    
    let username: String
    let address: String
    
    var body: some View {
        VStack {
            Text(username)
            Text(address)
        }
    }
}

struct ProfileTextStack_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTextStack(username: "zander", address: "0x1234...5678")
    }
}
