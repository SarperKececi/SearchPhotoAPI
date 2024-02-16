//
//  DataModel.swift
//  PhotoSearchApp
//
//  Created by Sarper Kececi on 14.02.2024.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Codable {
    let id: String?
    let urls: PhotoURLs?
 
}

struct PhotoURLs: Codable {
   
    let regular: String
  
  
}
