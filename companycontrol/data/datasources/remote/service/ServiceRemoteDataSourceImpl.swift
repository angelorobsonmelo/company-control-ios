//
//  ServiceRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Firebase
import Combine

class ServiceRemoteDataSourceImpl: ServiceRemoteDataSource {
    
    let db: Firestore
    private let collectionName = "service"
    
    init(db: Firestore) {
        self.db = db
    }
    
    
    func save(request: ServiceRequest) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { promise in
            let categoryRef = self.db.collection("category").document(request.categoryId)
            let companyRef = self.db.collection("company").document(request.companyId)
            let ref = self.db.collection(self.collectionName).document(request.id)
            
            ref.setData(
                [
                    "id" : request.id,
                    "title": request.title,
                    "description": request.description,
                    "date": request.date,
                    "user_email": request.userEmail,
                    "amount": request.amount,
                    "category_ref": categoryRef,
                    "company_ref": companyRef
                ]
            ) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
                
            }
        }
        
        return future.eraseToAnyPublisher()
    }
    
    
    
}
