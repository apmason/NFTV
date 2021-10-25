//
//  AccountDetailView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct AccountDetailView: View {
    
    let accountInfo: AccountInfo
    
    //    AccountImageView(imageURL: accountInfo.accountURL)
    //        .frame(width: geo.size.height)
    //        .frame(maxHeight: .infinity)
    var proxy: GeometryProxy? {
        didSet {
            guard let prox = proxy else {
                return
            }
            
            customHeight = prox.size.height
        }
    }
    @State var customHeight: CGFloat = 0
    
    func setProx(_ prox: GeometryProxy) {
        print("proxy set")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Color.black
                    .aspectRatio(1, contentMode: .fit)
                
                AccountTextStack(username: accountInfo.username ?? "Unnamed",
                                 address: accountInfo.displayableAddress)
                    .frame(alignment: .leading)
            }
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(accountInfo: AccountInfo(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                                   username: "zeent",
                                                   accountURL: nil))
    }
}
