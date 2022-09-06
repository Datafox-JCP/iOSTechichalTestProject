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
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private let validator = CreateValidator()
    
    @MainActor
    func create() async {
        do {
            try validator.validate(person)
            
            state = .submitting
            
            let enconder = JSONEncoder()
            enconder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? enconder.encode(person)
            
            try await NetworkManager.shared.request(methodType: .POST(data: data),
                                                    "https://reqres.in/api/users?delay=3")
            
            state = .successful
            
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkManager.NetworkingError:
                self.error = .networking(error: error as! NetworkManager.NetworkingError)
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
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

extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    
    var errorDescription: String? {
        switch self {
        case .networking(let err),
            .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}
