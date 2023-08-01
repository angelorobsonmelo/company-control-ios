//
//  LogoutView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 01/08/2023.
//

import SwiftUI

struct LogoutView: View {
    
    @State private var showingDeleteConfirmation = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    
    var body: some View {
        Button(action: {
            showingDeleteConfirmation = true
        }) {
            HStack {
                Image(systemName: "power")
                Text("LOG_OUT".localized)
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("SIGN_OUT_TITLE".localized),
                message: Text("SIGN_OUT_MSG".localized),
                primaryButton: .destructive(Text("OK".localized)) {
                    viewModel.signOut()
                },
                secondaryButton: .cancel {
                    
                }
            )
        }
    }
}
