//
//  ExpenseCategoryRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Firebase


class ExpenseCategoryRemoteDataSourceImpl: ExpenseCategoryRemoteDataSource {
    
    
    let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseCategoryResponse], Error>) -> Void) {
        let ref = db.collection("expense_category")
        
        ref.addSnapshotListener { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            let categories = snapshot.documents.map { document in
                ExpenseCategoryResponse(
                    id: document["id"] as? String ?? "",
                    name: document["name"] as? String ?? "",
                    userEmail: document["user_email"] as? String ?? ""
                )
            }
            
            completion(.success(categories))
        }
        
    }
    
    
    
}
