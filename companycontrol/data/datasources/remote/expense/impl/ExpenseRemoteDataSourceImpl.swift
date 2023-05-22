//
//  ExpenseDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation
import Firebase

class ExpenseRemoteDataSourceImpl: ExpenseRemoteDataSource  {
    
    
    private let collectionName = "expense"
    
    let firestore: Firestore
    
    init(fireStore: Firestore) {
        self.firestore = fireStore
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let id = Utils.generateCustomID()

        let ref = firestore.collection(collectionName).document(id)
        ref.setData(
            [
                "id" : id,
                "name": request.title,
                "user_email": request.userEmail,
                "expense_category_id": request.expenseCategoryId
            ]
        ) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestore.collection(collectionName).document(id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func update(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        firestore.collection(collectionName).document(request.id).updateData([
            "name": request.title
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
}
