//
//  ExpenseDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation
import Firebase

class ExpenseRemoteDataSourceImpl: ExpenseRemoteDataSource  {
    
    
    let firestore: Firestore
    
    init(fireStore: Firestore) {
        self.firestore = fireStore
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let id = Utils.generateCustomID()

        let ref = firestore.collection("expense_category").document(id)
        ref.setData(
            [
                "id" : id,
                "name": request.name,
                "user_email": request.userEmail
            ]
        ) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    
    }
    
    
    
    
    
}
