//
//  ProfileDetailView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct ProfileDetailView: View {
    
    let profile: OpenSeaProfile
    
    var body: some View {
        HStack {
            ProfileImageView()
            ProfileTextStack(username: profile.username ?? "Unnamed", address: profile.address)
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(profile: OpenSeaProfile(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                                  username: "zeent"))
    }
}
