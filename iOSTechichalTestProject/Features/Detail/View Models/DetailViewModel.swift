//
//  DetailsViewModel.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 24/08/22.
//

import Foundation

final class DetailViewModel: ObservableObject {
    
    @Published private(set) var userInfo: UserDetailResponse?
    @Published private(set) var error: NetworkManager.NetworkingError?
    @Published private(set) var isLoading = false
    @Published var hasError = false
    
    func fetchDetail(for id: Int) {
        isLoading = true
        NetworkManager.shared.request("https://reqres.in/api/users/\(id)",
                                      type: UserDetailResponse.self) { [weak self] res in
            DispatchQueue.main.async {
                defer { self?.isLoading = false }
                switch res {
                case .success(let response):
                    self?.userInfo = response
                case .failure(let error):
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkingError
                }
            }
        }
    }
}
