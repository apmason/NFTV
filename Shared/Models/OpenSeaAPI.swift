//
//  OpenSeaAPI.swift
//  NFTV (iOS)
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

enum OpenSeaAPIError: Error {
    case defaultError(Error)
    case badData
}

class OpenSeaAPI {
    
    static func fetchAssets(for address: String, completion: @escaping ((OpenSeaAPIError?) -> Void)) {
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=\(address)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                // need to handle bad errors
                if let error = error {
                    completion(.defaultError(error))
                } else {
                    completion(.badData)
                }
                
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    completion(.badData)
                    return
                }
                
                // We've made it to this step, the user is signed in but has no assets.
                let account = OpenSeaAccount(address: address)
                
                // Regardless if this account has assets, assign it as the active account at the end of this function.
                defer {
                    DispatchQueue.main.async {
                        OpenSeaModel.shared.activeAccount = account
                    }
                }
                
                guard let assets = json["assets"] as? [[String: Any]] else {
                    print("No assets")
                    return
                }
                
                // TODO: Parse assets
                for asset in assets {
                    let imageURL = asset["image_url"] as! String
                    let videoURL = asset["animation_url"] as? String
                    if videoURL != nil && videoURL != "" {
                        print("Video url is \(videoURL!)")
                    }
                
                    // TODO: - Clean this up
                    let asset = OpenSeaAsset(imageURL: URL(string: imageURL)!)
                    account.assets.append(asset)
                }
                
                completion(nil)
                
            } catch {
                completion(.defaultError(error))
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

class OpenSeaAsset: Identifiable, ObservableObject {
    
    let imageURL: URL
    
    var image: ImageWrapper? {
        get {
            print("get image")
            return self.image
        } set {
            print("set image")
            self.image = newValue
        }
    }

    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    func retrieveURL() {
        // see if we have in our cache
    }
}
