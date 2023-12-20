//
//  NetworkManager.swift
//  YelpDemo
//
//  Created by duongpham on 14/05/2023.
//

import Foundation
import CoreLocation
import Combine

protocol NetworkManagerType {
    func fetchBusinesses(with keyword: String, searchType: SearchType, location: CLLocationCoordinate2D?) async throws -> Result<SearchBusinessResponse, NetworkError>
    func fetchBusinessDetail(with id: String) async throws -> Business?
    func fetchBusinessesFuture(with keyword: String, searchType: SearchType, location: CLLocationCoordinate2D?) -> AnyPublisher<SearchBusinessResponse, NetworkError>
}

enum NetworkError: Error {
    case invalidUrl
    case noData
}

class NetworkManager: NetworkManagerType {
    private var subscriptions = Set<AnyCancellable>()
    func fetchBusinessesFuture(with keyword: String, searchType: SearchType, location: CLLocationCoordinate2D?) -> AnyPublisher<SearchBusinessResponse, NetworkError> {
        let router = ApiRouter.searchBusiness(keyword: keyword, type: searchType, location: location)
        guard let url = router.makeURLRequest() else {
            return Fail<SearchBusinessResponse, NetworkError>(error: .invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpReponse = response as? HTTPURLResponse, httpReponse.statusCode == 200 else {
                    throw NetworkError.noData
                }
                return data
            }
            .decode(type: SearchBusinessResponse.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let mapError = error as? NetworkError {
                    return mapError
                }
                return NetworkError.noData
            }
            .eraseToAnyPublisher()
    }
    

    func fetchBusinesses(with keyword: String, searchType: SearchType, location: CLLocationCoordinate2D?) async throws -> Result<SearchBusinessResponse, NetworkError> {
        let router = ApiRouter.searchBusiness(keyword: keyword, type: searchType, location: location)
        guard let request = router.makeURLRequest() else {
            return .failure(.invalidUrl)
        }
        
        let (data, _) = try await URLSession(configuration: .default).data(for: request)

        guard let response = try? JSONDecoder().decode(SearchBusinessResponse.self, from: data) else {
            return .failure(.noData)
        }
        return .success(response)
        
    }
    
    func fetchBusinessDetail(with id: String) async throws -> Business? {
        let router = ApiRouter.getBusinessDetail(id: id)
        guard let request = router.makeURLRequest() else {
            return nil
        }
        let (data, _) = try await URLSession(configuration: .default).data(for: request)
        return try? JSONDecoder().decode(Business.self, from: data)
    }
}
