//
//  Utils.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

class Utils {
    
   static func generateCustomID() -> String {
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


