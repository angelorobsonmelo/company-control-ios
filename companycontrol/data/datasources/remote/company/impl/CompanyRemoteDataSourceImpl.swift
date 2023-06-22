//
//  CompanyRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Firebase
import Combine


class CompanyRemoteDataSourceImpl: CompanyRemoteDataSource {
    
   
    
    let db: Firestore
    private let collectionName = "company"
    
    init(db: Firestore) {
        self.db = db
    }
    
    func getAll(userEmail: String) -> AnyPublisher<[CompanyResponse], Error> {
        let future = Future<[CompanyResponse], Error> { promise in
            let ref = self.db.collection(self.collectionName).whereField("user_email", isEqualTo: userEmail)
            
            ref.addSnapshotListener { snapshot, error in
                guard error == nil, let snapshot = snapshot else {
                    promise(.failure(error!))
                    return
                }
                
                let companies = snapshot.documents.map { document in
                    CompanyResponse(
                        id: document["id"] as? String ?? "",
                        address: document["address"] as? String ?? "",
                        contactNumber: document["contact_number"] as? String ?? "",
                        name: document["name"] as? String ?? "",
                        userEmail: document["user_email"] as? String ?? ""
                    )
                }
                
                promise(.success(companies))
                
            }
        }
        
        return future.eraseToAnyPublisher()
    }
    
    
//    func getAll(userEmail: String, completion: @escaping (Result<[CompanyResponse], Error>) -> Void) {
//        let ref = db.collection(collectionName).whereField("user_email", isEqualTo: userEmail)
//
//        ref.addSnapshotListener { snapshot, error in
//            guard error == nil, let snapshot = snapshot else {
//                completion(.failure(error!))
//                return
//            }
//
//            let categories = snapshot.documents.map { document in
//                CompanyResponse(
//                    id: document["id"] as? String ?? "",
//                    address: document["address"] as? String ?? "",
//                    contactNumber: document["contact_number"] as? String ?? "",
//                    name: document["name"] as? String ?? "",
//                    userEmail: document["user_email"] as? String ?? ""
//                )
//            }
//
//            completion(.success(categories))
//        }
//    }
    
    func save(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection(collectionName).document(request.id)
        ref.setData(
            [
                "id" : request.id,
                "name": request.name,
                "user_email": request.userEmail,
                "address": request.address,
                "contact_number": request.contactNumber
            ]
        ) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    func update(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(request.id).updateData(
            [
                "id" : request.id,
                "name": request.name,
                "user_email": request.userEmail,
                "address": request.address,
                "contact_number": request.contactNumber
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
    
    
}
