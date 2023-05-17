//
//  LoginView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import SwiftUI
import Firebase

struct AuthView: View {
    
    @ObservedObject var viewModel = DIContainer.shared.resolve(AuthViewModel.self)
    
    private let auth = DIContainer.shared.resolve(Auth.self)
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    @State private var snackBarMessage = ""
    @State private var snackBarType: SnackbarType = .error
    @State private var showSnackBar = false
    
    @State private var navigateToRegisterView = false
    
    
    
    var body: some View {
        NavigationView {
            if userIsLoggedIn {
                ExpenseCategoryView()
            } else {
                content
            }
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
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .padding(.top)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top)
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    login()
                } label: {
                    Text("Login")
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
                
                
                NavigationLink(destination: RegisterView(),
                               isActive: $navigateToRegisterView) { }
                
                Button {
                    navigateToRegisterView = true
                } label: {
                    Text("Have not an account? Sign up")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top)
                .offset(y: 110)
                
                
                SnackbarView(message: snackBarMessage, snackbarType: snackBarType, isShowing: $showSnackBar)
                    .frame(height: 40)
                    .offset(y: 200)
                
            }
            .frame(width: 350)
            .onAppear {
                if auth.currentUser != nil {
                    userIsLoggedIn = true
                } else {
                    userIsLoggedIn = false
                }
            }
            .onChange(of: viewModel.loginNetworkResult) { newValue in
                switch newValue {
                case .success(let success):
                    userIsLoggedIn = true
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
    
    func login() {
        viewModel.auth(email: email, password: password)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView()
//    }
//}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
