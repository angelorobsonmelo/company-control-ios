//
//  EditScheduleUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

class EditScheduleUseCaseImpl: EditScheduleUseCase {
    
    
    let repository: ScheduleRepository
    var cancellable: AnyCancellable?
    
    init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    func execute(request: ScheduleRequest) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard !request.title.isEmpty else {
                promise(.failure(ValidationFormEnum.emptyField(reason: "TITLE_EMPTY_FIELD_MSG".localized)))
                return
            }
            
            let publisher = self?.repository.update(request: request)
            
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
