//
//  ProfileView.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    let profile: OpenSeaProfile
    
    var body: some View {
        Text("Image go here")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: OpenSeaProfile(address: "0x123456789123456789", username: nil))
    }
}
