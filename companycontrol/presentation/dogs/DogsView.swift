//
//  WorksView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import SwiftUI

struct DogsView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            List(dataManager.dogs, id: \.id) { dog in
                Text(dog.breed)
                
            }
            .navigationTitle("Dogs")
            .navigationBarItems(trailing: Button(action: {
                showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showPopup) {
                NewDogView()
            }
        }
       
    }
}

struct WorksView_Previews: PreviewProvider {
    static var previews: some View {
        DogsView()
            .environmentObject(DataManager())
    }
}
