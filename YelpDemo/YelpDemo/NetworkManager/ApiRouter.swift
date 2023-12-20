//
//  ApiRouter.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import Foundation
import CoreLocation

enum ApiRouter {
    case searchBusiness(keyword: String, type: SearchType, location: CLLocationCoordinate2D?)
    case getBusinessDetail(id: String)
}

extension ApiRouter {
    static var baseUrl: String = "https://api.yelp.com/v3/businesses/"
    static var apiKey: String = "O1vaciVlzmDSPQNDVkC6jSOn-t_JaVm0Dje_WqvOY09niBY33CI06OTcoRzcg_diNwuuWe4NoJyQimW-Fd-9RUwNMS4McY88IA3-0Xs2wQb9gmCG5OQQ2eKsYZxgZHYx"
    
    var urlString: String {
        return Self.baseUrl + path
    }
    
    var path: String {
        switch self {
        case .searchBusiness:
            return "search"
        case .getBusinessDetail(let id):
            return id
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case let .searchBusiness(keyword, searchType, location):
            switch searchType {
            case .businessName:
                guard let location = location else { return nil }
                return [
                    URLQueryItem(name: "term", value: keyword),
                    URLQueryItem(name: "latitude", value: String(location.latitude)),
                    URLQueryItem(name: "longitude", value: String(location.longitude))
                ]
            case .location:
                return [URLQueryItem(name: "location", value: keyword)]
            case .cuisineType:
                guard let location = location else { return nil }
                return [
                    URLQueryItem(name: "categories", value: keyword),
                    URLQueryItem(name: "latitude", value: String(location.latitude)),
                    URLQueryItem(name: "longitude", value: String(location.longitude))
                ]
            }
        default:
            return nil
        }
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(Self.apiKey)",
            "Accept": "application/json"
        ]
    }
    
    var method: String? {
        switch self {
        case .searchBusiness, .getBusinessDetail:
            return "GET"
        }
    }
    
    var body: Data? {
//        switch self {
//        case .getBusinessDetail(let id):
//            let json: [String: Any] = ["id": id]
//            let jsonData = try? JSONSerialization.data(withJSONObject: json)
//            return jsonData
//        default:
//            return nil
//        }
        return nil
    }
    
    func makeURLRequest() -> URLRequest? {
        let urlString = urlString
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.queryItems = parameters
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = method
            request.allHTTPHeaderFields = headers
            request.httpBody = body
            return request
        }
        return nil
    }
}
