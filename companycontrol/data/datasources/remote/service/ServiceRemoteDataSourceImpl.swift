//
//  ServiceRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

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
    
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error> {
           
        return self.db.collection(self.collectionName)
            .whereField("user_email", isEqualTo: userEmail)
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)
            .getDocumentsPublisher()
            .flatMap { querySnapshot -> AnyPublisher<[ServiceResponse], Error> in
                let fetchCategoryAndCompanyPublishers = querySnapshot.documents.compactMap { document -> AnyPublisher<ServiceResponse, Error>? in
                    guard let expenseCategoryRef = document.data()["category_ref"] as? DocumentReference,
                          let expenseCompanyRef = document.data()["company_ref"] as? DocumentReference else {
                        return nil
                    }
                    
                    let fetchCategoryPublisher = expenseCategoryRef.getDocumentPublisher().map { snapshot in
                        CategoryResponse(
                            id: snapshot.documentID,
                            name: snapshot.data()?["name"] as? String ?? "",
                            userEmail: snapshot.data()?["user_email"] as? String ?? "")
                    }.eraseToAnyPublisher()
                    
                    let fetchCompanyPublisher = expenseCompanyRef.getDocumentPublisher().map { snapshot in
                        CompanyResponse(
                            id: snapshot.documentID,
                            address: snapshot.data()?["address"] as? String ?? "",
                            contactNumber: snapshot.data()?["contact_number"] as? String ?? "",
                            name: snapshot.data()?["name"] as? String ?? "",
                            userEmail: snapshot.data()?["user_email"] as? String ?? ""
                        )
                    }.eraseToAnyPublisher()
                    
                    return Publishers.Zip(fetchCategoryPublisher, fetchCompanyPublisher)
                        .map { category, company -> ServiceResponse in
                            ServiceResponse(
                                id: document.documentID,
                                title: document.data()["title"] as? String ?? "",
                                description: document.data()["description"] as? String ?? "",
                                userEmail: document.data()["user_email"] as? String ?? "",
                                amount: document.data()["amount"] as? Double ?? 0.0,
                                date: (document.data()["date"] as? Timestamp)?.dateValue().formaterDate() ?? "",
                                category: category,
                                company: company
                            )
                        }
                        .eraseToAnyPublisher()
                }
                
                return Publishers.MergeMany(fetchCategoryAndCompanyPublishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }


    
    
}


extension DocumentReference {
    func getDocumentPublisher() -> Future<DocumentSnapshot, Error> {
        return Future { promise in
            self.getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(snapshot!))
                }
            }
        }
    }
}

extension Query {
    func getDocumentsPublisher() -> Future<QuerySnapshot, Error> {
        return Future<QuerySnapshot, Error> { promise in
            self.getDocuments { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                }
            }
        }
    }
}








