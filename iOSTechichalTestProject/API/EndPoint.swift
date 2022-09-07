    //
    //  Endpoint.swift
    //  iOSTechichalTestProject
    //
    //  Created by Juan Hernandez Pazos on 07/09/22.
    //

import Foundation

enum Endpoint {
    case people
    case detail(id: Int)
    case create(submissionData: Data?)
}

extension Endpoint {
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    var host: String { "reqres.in" }
    
    var path: String {
        switch self {
        case .people,
             .create:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .people, .detail:
            return .GET
        case .create(let data):
            return .POST(data: data)
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        #if DEBUG
        urlComponents.queryItems = [
            URLQueryItem(name: "delay", value: "2")
        ]
        #endif
        
        return urlComponents.url
    }
}
