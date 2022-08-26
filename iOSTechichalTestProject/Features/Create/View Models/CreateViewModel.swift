//
//  CreateViewModel.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 25/08/22.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: NetworkManager.NetworkingError?
    @Published var hasError = false
    
    func create() {
        state = .submitting
        
        let enconder = JSONEncoder()
        enconder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? enconder.encode(person)
        
        NetworkManager
            .shared
            .request(methodType: .POST(data: data),
                     "https://reqres.in/api/users?delay=3") { [weak self] res in
                
                DispatchQueue.main.async {
                    switch res {
                    
                    case .success:
                        self?.state = .successful
                    case .failure(let err):
                        self?.state = .unsuccessful
                        self?.hasError = true
                        self?.error = err as? NetworkManager.NetworkingError
                    }
                }
            }
    }
}

extension CreateViewModel {
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
}
