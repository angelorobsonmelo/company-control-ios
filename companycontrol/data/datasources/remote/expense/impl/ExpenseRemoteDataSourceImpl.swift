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

        let expenseCategoryRef = Firestore.firestore().collection("expense_category").document(request.expenseCategoryId)

        let ref = firestore.collection(collectionName).document(id)
        ref.setData(
            [
                "id" : id,
                "title": request.title,
                "description": request.description,
                "date": request.date,
                "user_email": request.userEmail,
                "amount": request.amount,
                "expense_category": expenseCategoryRef
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
