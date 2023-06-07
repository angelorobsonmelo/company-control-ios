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
        
        container.register(CategoryRemoteDataSource.self) { resolver in
            CategoryRemoteDataSourceImpl(db: resolver.resolve(Firestore.self)!)
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
        
        container.register(CategoryRepository.self) { resolver in
            CategoryRepositoryImpl(dataSource: resolver.resolve(CategoryRemoteDataSource.self)!)
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
        
        container.register(SaveCategoryUseCase.self) { resolver in
            SaveCategoryUseCaseImpl(repository: resolver.resolve(CategoryRepository.self)!)
        }
        
        container.register(UpdateExpenseUseCase.self) { resolver in
            UpdateExpenseUseCaseImpl(repository: resolver.resolve(ExpenseRepository.self)!)
        }
        
        container.register(DeleteCategoryUseCase.self) { resolver in
            DeleteCategoryUseCaseImpl(repository: resolver.resolve(CategoryRepository.self)!)
        }
        
        container.register(UpdateCategoryUseCase.self) { resolver in
            UpdateCategoryUseCaseImpl(repository: resolver.resolve(CategoryRepository.self)!)
        }
        
        container.register(GetCategoriesUseCase.self) { resolver in
            GetCategoriesUseCaseImpl(repository: resolver.resolve(CategoryRepository.self)!)
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
                getExpenseCategoriesUseCase: resolver.resolve(GetCategoriesUseCase.self)!,
                deleteExpenseUseCase: resolver.resolve(DeleteExpenseUseCase.self)!, updateExpenseUseCase: resolver.resolve(UpdateExpenseUseCase.self)!
            )
        }
        
        container.register(AuthViewModel.self) { resolver in
            AuthViewModel(
                authUseCase: resolver.resolve(AuthUseCase.self)!,
                registerUseCase: resolver.resolve(RegisterUseCase.self)!
            )
        }
        
        container.register(CategoryViewModel.self) { resolver in
            CategoryViewModel(
                getExpenseUseCase: resolver.resolve(GetCategoriesUseCase.self)!,
                auth: resolver.resolve(Auth.self)!,
                saveCategoryUseCase: resolver.resolve(SaveCategoryUseCase.self)!,
                deleteCategoryUseCase: resolver.resolve(DeleteCategoryUseCase.self)!,
                updateCategoryUseCase: resolver.resolve(UpdateCategoryUseCase.self)!
            )
        }
    }
    
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        return container.resolve(serviceType)!
    }
    
}
