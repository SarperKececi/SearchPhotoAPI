//
//  APIService.swift
//  PhotoSearchApp
//
//  Created by Sarper Kececi on 14.02.2024.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    let url = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=RavTfyYuOHSegsmj9dVRwWh_weRfbWXVMvzuUg990AQ"
    
    
    
    struct Constants {
        static let accessKey = "RavTfyYuOHSegsmj9dVRwWh_weRfbWXVMvzuUg990AQ"
        static let baseUrl = "https://api.unsplash.com/search/photos"
        static let defaultPage = 1
        static let perPage = 100
        static let orderBy = "relevant"
      
    }
    
    func searchPhotos(query: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid query", code: 0, userInfo: nil)))
            return
        }

        // Oluşturulan URL'nin temel kısmı
        let baseUrlString = "\(Constants.baseUrl)?page=\(Constants.defaultPage)&query=\(encodedQuery)&client_id=\(Constants.accessKey)"

        // URL oluşturma
        guard let url = URL(string: baseUrlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(APIResponse.self, from: data)
                    completion(.success(result.results))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }

}
