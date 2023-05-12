//
//  SnackBarView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import SwiftUI

struct SnackbarView: View {
    let message: String
    let snackbarType: SnackbarType
    @Binding var isShowing: Bool
    var completion: (() -> Void)?

    
    var body: some View {
        VStack {
            Spacer()
            
            if isShowing {
                Text(message)
                    .bold()
                    .padding()
                    .background(snackbarType.backgroundColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .animation(.easeInOut)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowing = false
                                completion?()
                            }
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: isShowing) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        isShowing = false
                        completion?()
                    }
                }
            }
        }
    }
}

struct SnackBarView_Previews: PreviewProvider {
    
    @State static var showSnack = true

    static var previews: some View {
        SnackbarView(message: "Snack bar de exemplo", snackbarType: .error, isShowing: $showSnack)
    }
}
