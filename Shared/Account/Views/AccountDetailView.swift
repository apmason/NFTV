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
    
    @ObservedObject var accountInfo: AccountInfo
    
    @State private var customHeight: CGFloat?
    
    var body: some View {
        HStack(alignment: .top) {
            AccountImageView(imageWrapper: $accountInfo.imageWrapper)
                .frame(width: customHeight, height: customHeight, alignment: .leading)
                .clipShape(
                    Circle()
                )
            
            AccountTextStack(username: accountInfo.username ?? "-",
                             address: accountInfo.displayableAddress)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self,
                                               value: geo.size.height)
                })
            
            Spacer()
            
            Button("Settings") {
                OpenSeaModel.shared.showSettings = true
            }
            .frame(height: customHeight, alignment: .trailing)
        }
        .padding()
        .onPreferenceChange(HeightPreferenceKey.self) {
            customHeight = $0
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(accountInfo: AccountInfo(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                                   username: "zeent",
                                                   profileImageURL: nil))
    }
}
