//
//  NetworkManager.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 24/08/22.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func request<T: Codable>(methodType: MethodType = .GET,
                             _ absoluteURL: String,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: absoluteURL) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let request = buildRequest(from: url, methodType: methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let res = try decoder.decode(T.self, from: data)
                completion(.success(res))
                
            } catch {
                completion(.failure(NetworkingError.failToDecode(error: error)))
            }
        }
        
        dataTask.resume()
    }
    
    func request(methodType: MethodType = .GET,
                 _ absoluteURL: String,
                 completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: absoluteURL) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let request = buildRequest(from: url, methodType: methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            completion(.success(()))
        }
        
        dataTask.resume()
    }
}

extension NetworkManager {
    enum NetworkingError: LocalizedError {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failToDecode(error: Error)
    }
}

extension NetworkManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL isn't valid"
        case .invalidStatusCode:
            return "Status code alls into the wrong range"
        case .invalidData:
            return " Response data in invalid"
        case .failToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "Something went wrong \(err.localizedDescription)"
        }
    }
}

extension NetworkManager {
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
}

private extension NetworkManager {
    func buildRequest(from url: URL, methodType: MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        
        return request
    }
}
