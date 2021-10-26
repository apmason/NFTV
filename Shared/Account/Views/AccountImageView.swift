//
//  AccountImageView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI


// We'll always fetch and download a new image.
struct AccountImageView: View {
    
    @Binding var imageWrapper: ImageWrapper?
    
    var body: some View {
        if let imageWrapper = imageWrapper {
            #if os(macOS)
            Image(nsImage: imageWrapper.image)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fit)
            #else
            Image(uiImage: imageWrapper.image)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fit)
            #endif
        } else {
            Color.gray
        }
    }
}

struct AccountImageView_Previews: PreviewProvider {
    static var previews: some View {
        AccountImageView(imageWrapper: .constant(nil))
    }
}
