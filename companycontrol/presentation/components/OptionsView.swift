//
//  OptionsView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 22/05/2023.
//

import Foundation
import SwiftUI

struct OptionsView: View {
    @Binding var selectedOption: String?
    let options: [String]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        List(options, id: \.self) { option in
            Button(action: {
                self.selectedOption = option
                self.presentationMode.wrappedValue.dismiss()
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text(option)
            }
        }
        .navigationBarTitle("Options", displayMode: .inline)
    }
    
}
