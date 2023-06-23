//
//  SaveServiceUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine

class SaveServiceUseCaseImpl: SaveServiceUseCase {
    
    let repository: ServiceRepository
    var cancellable: AnyCancellable?
    
    init(repository: ServiceRepository) {
        self.repository = repository
    }
    
    func execute(request: ServiceRequest) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard !request.title.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Title can not be empty")))
                return
            }
            
            guard !request.description.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Description can not be empty")))
                return
            }
            
            guard request.amount > 0 else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Amount must be greater than zero")))
                return
            }
            
            guard !request.categoryId.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Category can not be empty")))
                return
            }
            
            guard !request.companyId.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Company can not be empty")))
                return
            }
            
            let publisher = self?.repository.save(request: request)
            
            self?.cancellable = publisher?
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        promise(.success(()))
                        self?.cancellable = nil
                    }
                } receiveValue: { _ in
                    // We don't care about the value here, as we're returning Void.
                }
        }
        .eraseToAnyPublisher()
        
        
    }
    
    
    
}
