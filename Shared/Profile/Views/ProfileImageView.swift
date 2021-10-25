//
//  ProfileImageView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

struct ProfileImageView: View {
    // add our URL here.
    
    
    var body: some View {
        #if os(macOS)
        
        #else
        AsyncImage(url: URL(string: "https://storage.googleapis.com/opensea-static/opensea-profile/27.png"))
        #endif
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView()
    }
}
