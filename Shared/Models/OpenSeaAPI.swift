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
    
    static var fetchLimit: Int = 50
    
    /// Recursively fetch all data
    private static func fetchData(address: String,
                                  index: Int,
                                  accountInfo: AccountInfo,
                                  updateAccountInfo: Bool,
                                  inputAssets: [OpenSeaAsset],
                                  completion: @escaping ((Result<[OpenSeaAsset], OpenSeaAPIError>) -> Void)) {
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=\(address)&limit=\(fetchLimit)&order_direction=desc&offset=\(index)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        var osAssets = inputAssets
        
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
                    completion(.success([]))
                    return
                }
                                
                // Have we parsed an owner?
                var haveParsedOwner = false
                
                for asset in assets {
                    let imagePath = asset["image_url"] as? String
                    var imageURL: URL?
                    if let imagePath = imagePath {
                        imageURL = URL(string: imagePath)
                    }
                    
                    // Only show assets with images
                    guard imageURL != nil else {
                        continue
                    }
                    
                    let animationPath = asset["animation_url"] as? String
                    var animationURL: URL?
                    if let videoPath = animationPath, videoPath != "" {
                        animationURL = URL(string: videoPath)
                    }
                    
                    // Because we're getting assets for a specific owner, the owner key for all assets will be the same.
                    // We'll grab the first one and pass that back.
                    if updateAccountInfo && !haveParsedOwner, let owner = asset["owner"] as? [String: Any] {
                        haveParsedOwner = true
                        if let imagePath = owner["profile_img_url"] as? String, let imageURL = URL(string: imagePath)  {
                            accountInfo.profileImageURL = imageURL
                        }
                        
                        if let user = owner["user"] as? [String: String], let username = user["username"] {
                            accountInfo.username = username
                        }
                    }
                    
                    let assetName = asset["name"] as? String ?? "-"
                    
                    var collectionName = "-"
                    if let collection = asset["collection"] as? [String: Any], let name = collection["name"] as? String {
                        collectionName = name
                    }
                    
                    let asset = OpenSeaAsset(assetName: assetName,
                                             collectionName: collectionName,
                                             imageURL: imageURL,
                                             animationURL: animationURL)
                    osAssets.append(asset)
                }
                
                // Only handle first 500 photos, add logic for scrolling for more later.
                if index < 10 && assets.count == fetchLimit {
                    fetchData(address: address,
                              index: index + 1,
                              accountInfo: accountInfo,
                              updateAccountInfo: false,
                              inputAssets: osAssets,
                              completion: completion)
                } else {
                    completion(.success(osAssets))
                }
                
            } catch {
                completion(.failure(.defaultError(error)))
            }
        }
        task.resume()
    }
    
    // Return an array of assets here
    static func fetchAssets(for address: String, completion: @escaping ((Result<(AccountInfo, [OpenSeaAsset]), OpenSeaAPIError>) -> Void)) {
        let accountInfo = AccountInfo(address: address)
        
        fetchData(address: address, index: 0,
                  accountInfo: accountInfo,
                  updateAccountInfo: true,
                  inputAssets: []) { result in
            switch result {
            case .success(let assets):
                completion(.success((accountInfo, assets)))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}
