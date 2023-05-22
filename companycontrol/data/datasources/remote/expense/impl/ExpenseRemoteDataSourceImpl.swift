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
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        firestore.collection("expense").whereField("user_email", isEqualTo: userEmail)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    completion(.failure(error!))
                    return
                }
                
                let group = DispatchGroup()
                
                var expenses: [ExpenseResponse] = []
                
                for document in documents {
                    guard let expenseCategoryRef = document.data()["expense_category"] as? DocumentReference else {
//                        completion(.failure(error?.localizedDescription))
                        return
                    }
                    
                    group.enter()
                    
                    expenseCategoryRef.getDocument { (categoryDoc, error) in
                        if let categoryDoc = categoryDoc, categoryDoc.exists {
                            let expenseCategory = ExpenseCategoryResponse(
                                id: categoryDoc.documentID,
                                name: categoryDoc.data()?["name"] as? String ?? "",
                                userEmail: categoryDoc.data()?["user_email"] as? String ?? "")
                            
                            let expense = ExpenseResponse(
                                id: document.documentID,
                                title: document.data()["title"] as? String ?? "",
                                description: document.data()["description"] as? String ?? "",
                                userEmail: document.data()["user_email"] as? String ?? "",
                                amount: document.data()["amount"] as? Double ?? 0.0,
                                date: (document.data()["date"] as? Timestamp)?.dateValue() ?? Date(),
                                expenseCategory: expenseCategory
                            )
                            
                            expenses.append(expense)
                        } else {
                            completion(.failure(error!))
                        }
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(expenses))
                }
            }
        
        
        
    }
    
    
}
