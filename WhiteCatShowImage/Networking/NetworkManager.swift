//
//  NetworkManager.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/26.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func getHtmlFromURL(urlString: String, completionHandler: @escaping (String) -> Void )
}

class NetworkManager: NetworkManagerProtocol {
    
    private let dispatchQueue = DispatchQueue(label: "terryyamg.whiteCatShowImage.manager", qos: .background, attributes: .concurrent)
    
    func getHtmlFromURL(urlString: String, completionHandler: @escaping (String) -> Void) {
        dispatchQueue.async {
            guard let dataURL = URL(string: urlString) else {
                print("Error: \(urlString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let htmlString = try String(contentsOf: dataURL, encoding: .utf8)
                completionHandler(htmlString)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
