//
//  SaveCompanyUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

class SaveCompanyUseCaseImpl: SaveCompanyUseCase {
    
    let repository: CompanyRepository
    var cancellable: AnyCancellable?

    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func execute(request: CompanyRequest) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard !request.name.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Name can not be empty")))
                return
            }
            
            guard !request.address.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Address can not be empty")))
                return
            }
            
            guard !request.contactNumber.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "Contact number can not be empty")))
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
