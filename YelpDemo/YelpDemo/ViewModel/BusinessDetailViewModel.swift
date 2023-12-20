//
//  BusinessDetailViewModel.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import Foundation

struct BusinessDetailItemDisplayModel: Identifiable {
    var id: String {
        return title + (description ?? "")
    }
    let title: String
    let description: String?
}

class BusinessDetailViewModel: ObservableObject {
    @Published var imageUrl: URL?
    @Published var detailItems: [BusinessDetailItemDisplayModel] = []
    let networkManager: NetworkManagerType
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchDetail(id: String) async {
        
        do {
            guard let business = try await networkManager.fetchBusinessDetail(with: id) else {
                return
            }
            let displayModels = self.makeItemDisplayModels(from: business)
            DispatchQueue.main.async {
                let imageUrlString = business.imageUrl ?? ""
                self.imageUrl = URL(string: imageUrlString)
                self.detailItems = displayModels
            }
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func makeItemDisplayModels(from bussinessDetail: Business) -> [BusinessDetailItemDisplayModel] {
        var displayModels: [BusinessDetailItemDisplayModel] = []
        let name = BusinessDetailItemDisplayModel(title: "Name", description: bussinessDetail.name)
        let address = BusinessDetailItemDisplayModel(title: "Address", description: bussinessDetail.location?.displayAddress?.joined(separator: ","))
        let category = BusinessDetailItemDisplayModel(title: "Category", description: bussinessDetail.categories?.first?.title)
        let operation = BusinessDetailItemDisplayModel(title: "Hours of operation", description: "")
        let rating = BusinessDetailItemDisplayModel(title: "Rating", description: String(bussinessDetail.rating ?? 0))
        displayModels.append(name)
        displayModels.append(address)
        displayModels.append(category)
        displayModels.append(operation)
        displayModels.append(rating)
        return displayModels
    }
}
