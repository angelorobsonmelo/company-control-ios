//
//  DataManager.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import Firebase

class DataManager: ObservableObject {
    
    @Published var dogs: [Dog] = []
    
    
    init() {
        fetchDogs()
    }
    
    func fetchDogs() {
        dogs.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        
        ref.addSnapshotListener { snapshot, error in
            self.dogs.removeAll()

            guard error == nil, let snapshot = snapshot else {
                print(error?.localizedDescription)
                return
            }
            
            for document in snapshot.documents {

                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let bread = data["breed"] as? String ?? ""
                
                let dog = Dog(id: id, breed: bread)
                self.dogs.append(dog)
            }
        }
        
    }
    
    func addDog(dogBreed: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Dogs").document(generateCustomID())
        ref.setData(
            ["breed": dogBreed, "id": generateCustomID()]
        ) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func generateCustomID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let idLength = 20
        
        var id = ""
        for _ in 0..<idLength {
            let randomIndex = Int.random(in: 0..<letters.count)
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            id.append(randomCharacter)
        }
        
        return id
    }
}
