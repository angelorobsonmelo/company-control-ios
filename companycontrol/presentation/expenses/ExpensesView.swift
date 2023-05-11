//
//  ExpensesView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import SwiftUI

struct ExpensesView: View {
    
    @ObservedObject var viewModel = DIContainer.shared.resolve(ExpenseViewModel.self)

    
    var body: some View {
           VStack {
               switch viewModel.networkResult {
               case .loading:
                   ProgressView() // Mostra um indicador de progresso quando estiver carregando
               case .error(let message):
                   Text("Erro: \(message ?? "")") // Mostra o erro, se houver
               case .success(let user):
                   if let user = user {
                       Text("Nome: \(user.name), Email: \(user.email)") // Mostra as informações do usuário, se a requisição for bem-sucedida
                   }
               case .idle:
                   EmptyView() // Não mostra nada quando estiver em estado ocioso
               }
               
               Button("Fazer Requisição") {
                   viewModel.fetchData() // Chama o método fetchData() ao clicar no botão
               }
           }
       }
}
