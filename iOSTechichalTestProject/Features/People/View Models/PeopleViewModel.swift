//
//  PeopleViewModel.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 24/08/22.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkManager.NetworkingError?
    @Published private(set) var viewSate: ViewState?
    @Published var hasError = false
    
    private var page = 1
    private var totalPages: Int?
    
    var isLoading: Bool {
        viewSate == .loading
    }
    
    var isFetching: Bool {
        viewSate == .fetching
    }
    
    @MainActor
    func fetchUsers() async {
        reset()
        viewSate = .loading
        defer { viewSate = .finished }
        
        do {
            let response = try await NetworkManager.shared.request(.people(page: page),
                                                                   type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfusers() async {
        
        guard page != totalPages else { return }
        
        viewSate = .fetching
        defer { viewSate = .finished }
        
        page += 1
        
        do {
            let response = try await NetworkManager.shared.request(.people(page: page),
                                                                   type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users += response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}

extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PeopleViewModel {
    func reset() {
        if viewSate == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewSate = nil
        }
    }
}
