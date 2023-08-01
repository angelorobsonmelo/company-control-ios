//
//  ScheduleViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine
import Firebase

class ScheduleViewModel: ObservableObject {
    
    private let auth: Auth
    private let saveScheduleUseCase: SaveScheduleUseCase
    private let getAllSchedulesUseCase: GetAllSchedulesUseCase
    private let deleteScheduleUseCase: DeleteScheduleUseCase
    private let editScheduleUseCase: EditScheduleUseCase
    
    init(
        auth: Auth,
        saveScheduleUseCase: SaveScheduleUseCase,
        getAllSchedulesUseCase: GetAllSchedulesUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase,
        editScheduleUseCase: EditScheduleUseCase
    ) {
        self.auth = auth
        self.saveScheduleUseCase = saveScheduleUseCase
        self.getAllSchedulesUseCase = getAllSchedulesUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
        self.editScheduleUseCase = editScheduleUseCase
    }
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isSaved = false
    
    @Published var expensesViews: [ScheduleViewData] = []
    
    var groupedCosts: [String: [ScheduleViewData]] {
        Dictionary(grouping: expensesViews) { cost in
            cost.date.formatStringDate(dateFormat: "dd/MM/yyyy", identifier: "pt-BR") ?? ""
        }
    }

    var sortedDates: [String] {
        groupedCosts.keys.sorted { date1, date2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = Locale(identifier: "pt-BR")
            guard let d1 = dateFormatter.date(from: date1),
                  let d2 = dateFormatter.date(from: date2) else {
                return false
            }
            return d1 > d2
        }
    }

    var total: String {
        let allSchedules = groupedCosts.values.flatMap { $0 }
        let totals = total(of: allSchedules)
        return "\(totals.notCompleted)"
    }
    
    var totalConcluded: String {
        let allSchedules = groupedCosts.values.flatMap { $0 }
        let totals = total(of: allSchedules)
        return "\(totals.completed)"
    }
    
   private func total(of schedules: [ScheduleViewData]) -> (completed: Int, notCompleted: Int) {
        let totalCompleted = schedules.filter { $0.completed }.count
        let totalNotCompleted = schedules.filter { !$0.completed }.count
        return (completed: totalCompleted, notCompleted: totalNotCompleted)
    }
    
    func save(
        title: String,
        description: String,
        date: Date,
        completed: Bool
    ) {
        if let email = self.auth.currentUser?.email {
            let request = ScheduleRequest(
                id: Utils.generateCustomID(),
                title: title,
                description: description,
                date: date,
                userEmail: email,
                completed: completed)
            
           
            self.saveScheduleUseCase.execute(request: request)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case let validationError as ValidationFormEnum:
                            switch validationError {
                            case .emptyField(let reason):
                                print("Empty field error: \(reason)")
                                self.showAlertDialog = true
                                self.dialogMessage = reason
                            }
                        default:
                            print("Unknown error: \(error)")
                        }
                        
                    case .finished:
                        self.showAlertDialog = true
                        self.dialogMessage = "Save Successfully"
                        self.isSaved = true
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &cancellables)

            
        }
    }
    
    
    func getAll(startDate: Date, endDate: Date) {
        if let email = self.auth.currentUser?.email {
            self.getAllSchedulesUseCase.execute(userEmail: email, startDate: startDate, endDate: endDate)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .map {
                    $0.map { item in
                        ScheduleViewData(
                            id: item.id,
                            title: item.title,
                            description: item.description,
                            date: item.date,
                            userEmail: item.userEmail,
                            completed: item.completed)
                    }.sorted { !$0.completed && $1.completed }
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        break
                    case .finished:
                        break
                    }
                } receiveValue: { servicesViewData in
                    self.expensesViews = servicesViewData
                }
                .store(in: &cancellables)
        }
    }
    
    func remove(at position: Int, from date: String) {
        let itemToDelte = groupedCosts[date]![position]
            
        deleteScheduleUseCase.execute(id: itemToDelte.id)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showAlertDialog = true
                    self.dialogMessage = error.localizedDescription
                case .finished:
                    break
                }
                
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

    }
    
    func update(
        id: String,
        title: String,
        description: String,
        date: Date,
        completed: Bool
    ) {
        if let email = self.auth.currentUser?.email {
            let request = ScheduleRequest(
                id: id,
                title: title,
                description: description,
                date: date,
                userEmail: email,
                completed: completed)
            
           
            self.editScheduleUseCase.execute(request: request)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case let validationError as ValidationFormEnum:
                            switch validationError {
                            case .emptyField(let reason):
                                print("Empty field error: \(reason)")
                                self.showAlertDialog = true
                                self.dialogMessage = reason
                            }
                        default:
                            print("Unknown error: \(error)")
                        }
                        
                    case .finished:
                        self.showAlertDialog = true
                        self.dialogMessage = "Save Successfully"
                        self.isSaved = true
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &cancellables)

            
        }
    }
    
}
