//
//  DIContainer.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Swinject
import Foundation
import Firebase

class DIContainer {
    
    
    static let shared = DIContainer()
    
    private let container = Swinject.Container()
    
    
    private init() {
        remoteDataSourcesInjections()
        reposotoriesInjections()
        useCasesInjections()
        viewModelsInjections()
    }
    
    fileprivate func remoteDataSourcesInjections()  {
        // Firebase Auth
        container.register(Auth.self) { _ in
            Auth.auth()
        }
        
        // FireStore
        container.register(Firestore.self) { _ in
            Firestore.firestore()
        }
        
        container.register(AuthRemoteDataSource.self) { resolver in
            AuthRemoteDataSourceImpl(auth: resolver.resolve(Auth.self)!)
        }
        
        container.register(ExpenseRemoteDataSource.self) { resolver in
            ExpenseRemoteDataSourceImpl(fireStore: resolver.resolve(Firestore.self)!)
        }
        
        container.register(ExpenseCategoryRemoteDataSource.self) { resolver in
            ExpenseCategoryRemoteDataSourceImpl(db: resolver.resolve(Firestore.self)!)
        }
    }
    
    fileprivate func reposotoriesInjections() {
        // Repositories
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(remoteDataSource: resolver.resolve(AuthRemoteDataSource.self)!)
        }
        
        container.register(ExpenseRepository.self) { resolver in
            ExpenseRepositoryImpl(remoteDataSource: resolver.resolve(ExpenseRemoteDataSource.self)!)
        }
        
        container.register(ExpenseCategoryRepository.self) { resolver in
            ExpenseCategoryRepositoryImpl(dataSource: resolver.resolve(ExpenseCategoryRemoteDataSource.self)!)
        }
    }
    
    fileprivate func useCasesInjections() {
        // Use cases
        container.register(GetExpensesUseCase.self) { resolver in
            GetExpensesUseCaseImpl(repository: resolver.resolve(ExpenseRepository.self)!)
        }
        
        container.register(DeleteExpenseUseCase.self) { resolver in
            DeleteExpenseUseCaseImpl(dataSource: resolver.resolve(ExpenseRepository.self)!)
        }
        
        container.register(SaveExpenseCategoryUseCase.self) { resolver in
            SaveExpenseCategoryUseCaseImpl(repository: resolver.resolve(ExpenseCategoryRepository.self)!)
        }
        
        container.register(UpdateExpenseUseCase.self) { resolver in
            UpdateExpenseUseCaseImpl(repository: resolver.resolve(ExpenseRepository.self)!)
        }
        
        container.register(DeleteExpenseCategoryUseCase.self) { resolver in
            DeleteExpenseCategoryUseCaseImpl(repository: resolver.resolve(ExpenseCategoryRepository.self)!)
        }
        
        container.register(UpdateExpenseCategoryUseCase.self) { resolver in
            UpdateExpenseCategoryUseCaseImpl(repository: resolver.resolve(ExpenseCategoryRepository.self)!)
        }
        
        container.register(GetExpenseCategoriesUseCase.self) { resolver in
            GetExpenseCategoriesUseCaseImpl(repository: resolver.resolve(ExpenseCategoryRepository.self)!)
        }
        
        container.register(SaveExpenseUseCase.self) { resolver in
            SaveExpenseUseCaseImpl(repository: resolver.resolve(ExpenseRepository.self)!)
        }
        
        container.register(AuthUseCase.self) { resolver in
            AuthUseCaseImpl(repository: resolver.resolve(AuthRepository.self)!)
        }
        
        container.register(RegisterUseCase.self) { resolver in
            RegisterUseCaseImpl(remoteDataSource: resolver.resolve(AuthRemoteDataSource.self)!)
        }
    }
    
    fileprivate func viewModelsInjections() {
        // ViewModels
        container.register(ExpenseViewModel.self) { resolver in
            ExpenseViewModel(
                getExpensesUseCase: resolver.resolve(GetExpensesUseCase.self)!,
                auth: resolver.resolve(Auth.self)!,
                saveExpenseUseCase: resolver.resolve(SaveExpenseUseCase.self)!,
                getExpenseCategoriesUseCase: resolver.resolve(GetExpenseCategoriesUseCase.self)!,
                deleteExpenseUseCase: resolver.resolve(DeleteExpenseUseCase.self)!, updateExpenseUseCase: resolver.resolve(UpdateExpenseUseCase.self)!
            )
        }
        
        container.register(AuthViewModel.self) { resolver in
            AuthViewModel(
                authUseCase: resolver.resolve(AuthUseCase.self)!,
                registerUseCase: resolver.resolve(RegisterUseCase.self)!
            )
        }
        
        container.register(ExpenseCategoryViewModel.self) { resolver in
            ExpenseCategoryViewModel(
                getExpenseUseCase: resolver.resolve(GetExpenseCategoriesUseCase.self)!,
                auth: resolver.resolve(Auth.self)!,
                saveCategoryUseCase: resolver.resolve(SaveExpenseCategoryUseCase.self)!,
                deleteCategoryUseCase: resolver.resolve(DeleteExpenseCategoryUseCase.self)!,
                updateCategoryUseCase: resolver.resolve(UpdateExpenseCategoryUseCase.self)!
            )
        }
    }
    
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        return container.resolve(serviceType)!
    }
    
}
