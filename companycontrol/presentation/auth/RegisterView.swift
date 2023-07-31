//
//  LoginView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import SwiftUI
import Firebase

struct RegisterView: View {
    
    @ObservedObject var viewModel = DIContainer.shared.resolve(AuthViewModel.self)
    
    private let auth = DIContainer.shared.resolve(Auth.self)
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    @State private var snackBarMessage = ""
    @State private var snackBarType: SnackbarType = .error
    @State private var showSnackBar = false
    
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        if userIsLoggedIn {
            WorksView()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            
            VStack {
                Text("REGISTER".localized)
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                TextField("EMAIL".localized, text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .placeholder(when: email.isEmpty) {
                        Text("EMAIL".localized)
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                SecureField("PASSWORD".localized, text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .autocapitalization(.none)
                    .placeholder(when: password.isEmpty) {
                        Text("PASSWORD".localized)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top)
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("SIGN_UP".localized)
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)
                
                SnackbarView(message: snackBarMessage, snackbarType: snackBarType, isShowing: $showSnackBar) {
                    if(snackBarType == .success) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .frame(height: 40)
                .offset(y: 200)
            }
            .frame(width: 350)
            .onChange(of: viewModel.registerNetworkResult) { newValue in
                switch newValue {
                case .success(let success):
                    snackBarMessage =  "REGISTER_SUCCESSFULLY".localized
                    snackBarType = .success
                    showSnackBar = true
                    
                    break
                case .error(let message):
                    snackBarMessage =  message.0 ?? "Error"
                    snackBarType = .error
                    showSnackBar = true
                    break
                case .loading:
                    print("Loading")
                    break
                case .idle:
                    print("Idle")
                    break
                }
            }
            
        }
        .ignoresSafeArea()
        
    }
    
    func register() {
        viewModel.register(email: email, password: password)
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


