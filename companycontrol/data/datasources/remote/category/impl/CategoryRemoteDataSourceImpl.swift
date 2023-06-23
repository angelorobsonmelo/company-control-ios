//
//  ExpenseCategoryRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Firebase
import Combine


class CategoryRemoteDataSourceImpl: CategoryRemoteDataSource {
    
    
    let db: Firestore
    private let collectionName = "category"

    
    init(db: Firestore) {
        self.db = db
    }
    
    func getAll(userEmail: String) -> AnyPublisher<[CategoryResponse], Error> {
        let subject = PassthroughSubject<[CategoryResponse], Error>()
        let ref = db.collection(collectionName).whereField("user_email", isEqualTo: userEmail)
        
        ref.addSnapshotListener { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                subject.send(completion: .failure(error!))
                return
            }
            
            let categories = snapshot.documents.map { document in
                CategoryResponse(
                    id: document["id"] as? String ?? "",
                    name: document["name"] as? String ?? "",
                    userEmail: document["user_email"] as? String ?? ""
                )
            }
            
            subject.send(categories)
        }
        
        return subject.eraseToAnyPublisher()
        
    }
    
    func saveCategory(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection(collectionName).document(request.id)
        ref.setData(
            [
                "id" : request.id,
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
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func update(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(request.id).updateData([
            "name": request.name
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
}
