//
//  AccountImageView.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import SwiftUI

class ImageDownloader: ObservableObject {
    #if os(macOS)
    @Published var image: NSImage?
    #endif
    
    func fetchImage(at url: URL) {
        print("Fetching the image here")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil, let data = data else {
                print("Error getting image, fail silently")
                return
            }
            
            print("data down here?")
            #if os(macOS)
            print("have image")
            self.image = NSImage(data: data)
            #endif
        }.resume()
    }
}

struct ImageContentView: View {
    // pass in the account URL (AccountInfo holds the URL)
    #if os(macOS)
    @ObservedObject
    var imageDownloader = ImageDownloader()
    #endif
    
    let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        imageDownloader.fetchImage(at: self.imageURL)
    }
    
    var body: some View {
        //TODO: Update this when Monterrey drops, then do an @available check for macOS 12.0. Otherwise use the standard version.
        if let image = imageDownloader.image {
            
        } else {
            
        }
        
        #if os(macOS)
        if imageDownloader.image != nil {
            Image(nsImage: imageDownloader.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color.gray
        }
        #endif
    }
}

// We'll always fetch and download a new image.
struct AccountImageView: View {
    
    let imageURL: URL?
    
    var body: some View {
        if let url = imageURL {
            ImageContentView(imageURL: url)
                .clipShape(Circle())
        } else {
            Color.gray
                .clipShape(Circle())
        }
    }
}

struct AccountImageView_Previews: PreviewProvider {
    static var previews: some View {
        AccountImageView(imageURL: URL(string: "https://storage.googleapis.com/opensea-static/opensea-account/27.png")!)
    }
}
