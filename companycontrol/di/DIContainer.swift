//
//  DIContainer.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Swinject
import Foundation

class DIContainer {
    
    
    static let shared = DIContainer()
    
    private let container = Swinject.Container()
    
    private init() {
        // Remote data sources
        container.register(ExpenseRemoteDataSource.self) { _ in
            ExpenseRemoteDataSourceImpl()
        }
        
        // Repositories
        container.register(ExpenseRepository.self) { resolver in
            ExpenseRepositoryImpl(remoteDataSource: resolver.resolve(ExpenseRemoteDataSource.self)!)
        }
        
        // Use cases
        container.register(GetExpensesUseCase.self) { resolver in
            GetExpensesUseCaseImpl(repository: resolver.resolve(ExpenseRepository.self)!)
        }
        
        // ViewModels
        container.register(ExpenseViewModel.self) { resolver in
            ExpenseViewModel(getExpensesUseCase: resolver.resolve(GetExpensesUseCase.self)!)
        }
    }
    
    
    
    func resolve<T>(_ serviceType: T.Type) -> T {
            return container.resolve(serviceType)!
        }
    
}
