//
//  ScheduleRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

import Combine

class ScheduleRemoteDataSourceImpl: ScheduleRemoteDataSource {
    
    
    let db: Firestore
    private let collectionName = "schedule"
    private var subject: PassthroughSubject<[ScheduleResponse], Error> = .init()
    
    // 2. Create a cancellable set to manage your subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init(db: Firestore) {
        self.db = db
    }
    
    func save(request: ScheduleRequest) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { promise in
            let ref = self.db.collection(self.collectionName).document(request.id)
            
            ref.setData(
                [
                    "id" : request.id,
                    "title": request.title,
                    "description": request.description,
                    "date": request.date,
                    "user_email": request.userEmail,
                    "completed": request.completed
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
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ScheduleResponse], Error> {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        var components = calendar.dateComponents([.year, .month, .day], from: startDate)
        let startDate = calendar.date(from: components)!

        components = calendar.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: 1, to: endDate)!)
        components.second = -1
        let endDate = calendar.date(from: components)!
        
        let query = self.db.collection(self.collectionName)
            .whereField("user_email", isEqualTo: userEmail)
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                self.subject.send(completion: .failure(error))
                return
            }
            
            if let snapshot = snapshot {
                let companies = snapshot.documents.map { document in
                    ScheduleResponse(
                        id: document["id"] as? String ?? "",
                        title: document["title"] as? String ?? "",
                        description: document["description"] as? String ?? "",
                        date: (document["date"] as? Timestamp)?.dateValue().formaterDate() ?? "",
                        userEmail: document["user_email"] as? String ?? "",
                        completed: document["completed"] as? Bool ?? false
                    )
                }
                self.subject.send(companies)
            }
        }
        
        return subject.eraseToAnyPublisher()
        
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
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
    
    func update(request: ScheduleRequest) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { promise in
            self.db.collection(self.collectionName).document(request.id).updateData(
                [
                    "id" : request.id,
                    "title": request.title,
                    "description": request.description,
                    "date": request.date,
                    "user_email": request.userEmail,
                    "completed": request.completed
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
