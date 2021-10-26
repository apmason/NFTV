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
    // Return an array of assets here
    static func fetchAssets(for address: String, completion: @escaping ((Result<[OpenSeaAsset], OpenSeaAPIError>) -> Void)) {
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=\(address)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                // need to handle bad errors
                if let error = error {
                    completion(.failure(.defaultError(error)))
                } else {
                    completion(.failure(.badData))
                }
                
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    completion(.failure(.badData))
                    return
                }
                
                guard let assets = json["assets"] as? [[String: Any]] else {
                    print("No assets")
                    return
                }
                
                var osAssets: [OpenSeaAsset] = []
                
                for asset in assets {
                    let imageURL = asset["image_url"] as! String
                    let videoURL = asset["animation_url"] as? String
                    if videoURL != nil && videoURL != "" {
                        print("Video url is \(videoURL!)")
                    }
                
                    // TODO: - Clean this up
                    let asset = OpenSeaAsset(imageURL: URL(string: imageURL)!)
                    osAssets.append(asset)
                }
                
                completion(.success(osAssets))
                
            } catch {
                completion(.failure(.defaultError(error)))
            }
        }
        task.resume()
    }
}
