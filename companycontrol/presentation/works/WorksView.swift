//
//  Works.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct WorksView: View {
    
    var body: some View {
        VStack {
           
            
            Text("testa testa")
        }.onAppear {
            do {
                try Auth.auth().signOut()
                print("Usuário deslogado com sucesso.")
                // Faça algo após o logout do usuário
            } catch let signOutError as NSError {
                print("Erro ao deslogar o usuário: \(signOutError.localizedDescription)")
                // Lide com o erro de logout do usuário
            }
        }
    }
}
