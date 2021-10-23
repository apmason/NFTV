//
//  OpenSeaAPI.swift
//  NFTV (iOS)
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

class OpenSeaModel: ObservableObject {
    
    static let shared = OpenSeaModel()
    
    @Published var activeProfile: OpenSeaProfile?
    
    private init() {}
}

class OpenSeaAPI {
    
    static func fetchAssets(for userAddress: String, completion: @escaping ((Error?) -> Void)) {
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=\(userAddress)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                // need to handle bad errors
                completion(error)
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
                
                let profile = OpenSeaProfile(ethAddress: userAddress)
                for asset in assets {
                    let imageURL = asset["image_url"] as! String
                    let videoURL = asset["animation_url"] as? String
                    if videoURL != nil && videoURL != "" {
                        print("Video url is \(videoURL!)")
                    }
                    print("Image url is \(imageURL)")
                
                    let asset = OpenSeaAsset(imageURL: URL(string: imageURL)!)
                    profile.assets.append(asset)
                }
                
                completion(nil)
                
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
    
    let imageURL: URL

}
