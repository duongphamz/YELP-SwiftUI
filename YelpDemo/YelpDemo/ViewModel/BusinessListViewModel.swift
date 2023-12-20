//
//  BusinessListViewModel.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

class BusinessListViewModel: ObservableObject {
    let networkManager: NetworkManagerType
    let locationService: LocationService
    
    let searchTextSubject = PassthroughSubject<String, Never>()
    let searchTypeSubject = CurrentValueSubject<SearchType, Never>(.businessName)
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerType = NetworkManager(),
         locationService: LocationService = LocationService()) {
        self.networkManager = networkManager
        self.locationService = locationService
        
        Publishers.CombineLatest(searchTextSubject.removeDuplicates().filter { !$0.isEmpty }.debounce(for: .seconds(1), scheduler: RunLoop.main), searchTypeSubject.removeDuplicates())
            .flatMap {
                self.fetchBusiness2(keyword: $0, searchType: $1)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.businesses = response.businesses
                }
            })
            .store(in: &subscriptions)
    }
    
    @Published var businesses: [Business] = []
    
    func fetchBusinesses(with keyword: String, searchType: SearchType) async {
        do {
            let result = try await networkManager.fetchBusinesses(with: keyword, searchType: searchType, location: locationService.currentLocation)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.businesses = response.businesses
                }
            case .failure(let error):
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    func fetchBusiness2(keyword: String, searchType: SearchType) -> AnyPublisher<SearchBusinessResponse, NetworkError> {
        return networkManager.fetchBusinessesFuture(with: keyword, searchType: searchType, location: locationService.currentLocation)
        
    }
    
    func startUpdatingLocation() {
        locationService.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationService.stopUpdatingLocation()
    }
}
