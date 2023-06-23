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
        let subject = PassthroughSubject<[CompanyResponse], Error>()
        
        let ref = self.db.collection(self.collectionName).whereField("user_email", isEqualTo: userEmail)
        
        ref.addSnapshotListener { snapshot, error in
            if let error = error {
                subject.send(completion: .failure(error))
            }
            
            if let snapshot = snapshot {
                let companies = snapshot.documents.map { document in
                    CompanyResponse(
                        id: document["id"] as? String ?? "",
                        address: document["address"] as? String ?? "",
                        contactNumber: document["contact_number"] as? String ?? "",
                        name: document["name"] as? String ?? "",
                        userEmail: document["user_email"] as? String ?? ""
                    )
                }
                subject.send(companies)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }

    
    func save(request: CompanyRequest) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { promise in
            let ref = self.db.collection(self.collectionName).document(request.id)
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
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
                
            }
        }
        
        return future.eraseToAnyPublisher()
        
    }
    
    func update(request: CompanyRequest) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { promise in
            self.db.collection(self.collectionName).document(request.id).updateData(
                [
                    "id" : request.id,
                    "name": request.name,
                    "user_email": request.userEmail,
                    "address": request.address,
                    "contact_number": request.contactNumber
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
    
    func delete(id: String) -> AnyPublisher<Void, Error>  {
        let future = Future<Void, Error> { promise in
            self.db.collection(self.collectionName).document(id).delete() { error in
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
