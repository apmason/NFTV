//
//  OpenSeaAPI.swift
//  NFTV (iOS)
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

class OpenSeaAPI {
    
    init() {
        fetchAssets(for: "0x0738f702d1a7364d356729cb8845701885c487a1")
    }
    
    func fetchAssets(for userAddress: String) {
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=\(userAddress)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                // present error to user
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                }
                
                print("Error, or no data")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("No json")
                    return
                }
                
                guard let assets = json["assets"] as? [[String: Any]] else {
                    print("No assets")
                    return
                }
                
                for asset in assets {
                    let imageURL = asset["image_url"] as! String
                    let videoURL = asset["animation_url"] as? String
                    if videoURL != nil && videoURL != "" {
                        print("Video url is \(videoURL!)")
                    }
                    print("Image url is \(imageURL)")
                }
                
            } catch {
                print("Deserializing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}

enum OpenSeaAssetType {
    case photo
    case video
    case animation
}

struct OpenSeaAsset {
    
    let ownerName: String
    let type: OpenSeaAssetType
    let url: URL
    
    // add content here?
    
    // if animation_url !? null use. mp4 (play video)
}
