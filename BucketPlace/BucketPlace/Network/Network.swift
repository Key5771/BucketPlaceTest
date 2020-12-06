//
//  Network.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import Foundation

class NetworkRequest {
    static let shared: NetworkRequest = NetworkRequest()
    
    func getData<Response: Decodable>(baseUrl: String, completion handler: @escaping (Response) -> Void) {
        let session = URLSession.shared
        
        guard let url = URL(string: "\(baseUrl)") else {
            fatalError("URL is nil")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                fatalError("\(String(describing: error))")
            }

            guard let data = data, let _ = response as? HTTPURLResponse else {
                fatalError("data is nil")
            }

            let decoder = JSONDecoder()
            guard let jsonData = try? decoder.decode(Response.self, from: data) else {
                fatalError("Decode Fail")
            }

            handler(jsonData)
        }

        dataTask.resume()
    }
}
