//
//  BalanceRemotaDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class nameBalanceRemotaDataSourceImpl: BalanceRemotaDataSource {
    
    
    let db: Firestore
    private let collectionName = "service"
    private var subject: PassthroughSubject<[BalanceResponse], Error> = .init()

       // 2. Create a cancellable set to manage your subscriptions
       private var cancellables = Set<AnyCancellable>()
    
    init(db: Firestore) {
        self.db = db
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[BalanceResponse], Error> {
        let query = self.db.collection(self.collectionName)
            .whereField("user_email", isEqualTo: userEmail)
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)

        // 3. Listen to updates
        query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.subject.send(completion: .failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            let fetchCategoryAndCompanyPublishers = documents.compactMap { document -> AnyPublisher<ServiceResponse, Error>? in
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

            Publishers.MergeMany(fetchCategoryAndCompanyPublishers)
                .collect()
                .sink(receiveCompletion: { _ in },
                      receiveValue: { self.subject.send($0) })
                .store(in: &self.cancellables)
        }

        return subject.eraseToAnyPublisher()
        
    }
    
    
}
