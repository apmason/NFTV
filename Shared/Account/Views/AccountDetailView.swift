//
//  AccountDetailView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

private extension AccountDetailView {
    struct HeightPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

struct AccountDetailView: View {
    
    let accountInfo: AccountInfo
    
    @State private var customHeight: CGFloat?
    
    func setProx(_ prox: GeometryProxy) {
        print("proxy set")
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Color.black
                .aspectRatio(1, contentMode: .fit)
                .frame(width: customHeight, height: customHeight, alignment: .leading)
            
            AccountTextStack(username: accountInfo.username ?? "Unnamed",
                             address: accountInfo.displayableAddress)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self,
                                               value: geo.size.height)
                
                })
        }
        .onPreferenceChange(HeightPreferenceKey.self) {
            customHeight = $0
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
