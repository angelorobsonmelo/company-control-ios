//
//  SchedulesView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//


import Foundation
import SwiftUI

struct SchedulesView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(ScheduleViewModel.self)
    @State private var showingAddDialog = false
    
    @State private var showingEditDialog = false
    @State private var selectedScheduleViewData: ScheduleViewData? = nil
    
    
    let calendar = Calendar.current
    let now = Date()
    
    @State private var startDate = Date()
    @State private var endDate =  Date()
    
    @State private var showingDeleteConfirmation = false
    @State private var itemPosition: Int? = nil
    @State private var dateGroupToDelete: String = ""
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("OPENED".localized + ": \(viewModel.total)")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text("CONCLUDED".localized + ": \(viewModel.totalConcluded)")
                        .font(.headline)
                        .padding(.top, 8)
                }
                
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: startDate) { newValue in
                            self.viewModel.getAll(startDate: startDate, endDate: endDate)
                        }
                    
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: endDate) { newValue in
                            self.viewModel.getAll(startDate: startDate, endDate: endDate)
                        }
                }
                .padding()
                
                List {
                    ForEach(viewModel.sortedDates, id: \.self) { date in
                        Section(header: Text(date)) {
                            ForEach(viewModel.groupedCosts[date]!, id: \.id) { item in
                                ZStack {
                                    let colorAndText = getColorAndText(completed: item.completed)

                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 45)

                                        Text(item.description)
                                            .font(.subheadline)
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 45)
                                            
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    
                                    HStack {
                                        Text(colorAndText.text)
                                            .foregroundColor(Color.white)
                                            .font(.caption2)
                                            .bold()
                                            .padding(4)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(colorAndText.color)
                                    .offset(x: -90, y: -100)
                                    .rotationEffect(.degrees(-45))
                                    
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.showingEditDialog = true
                                    self.selectedScheduleViewData = item
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                       let completed = !item.completed
                                       let color = item.completed ? Color.yellow : Color.green
                                    
                                        Button {
                                            self.viewModel.update(
                                                id: item.id,
                                                title: item.title,
                                                description: item.description,
                                                date: item.date.toDate(),
                                                completed: completed)
                                            
                                            print(item)
                                        } label: {
                                            Label(
                                                item.completed ? "REOPEN".localized : "CONCLUDE".localized,
                                                systemImage: item.completed ? "arrow.counterclockwise" : "checkmark.circle"
                                            )
                                        }
                                        .tint(color)
                                    }
                            }
                            .onDelete(perform: { indexSet in
                                deleteCategory(at: indexSet, date: date)
                            })
                        }
                    }
                }
            }
            .navigationBarTitle("SCHEDULES".localized, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAddDialog = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            
        }
        .onAppear {
            self.startDate = self.calendar.dateInterval(of: .month, for: now)?.start ?? Date()
            self.endDate = self.calendar.dateInterval(of: .month, for: now)?.end ?? Date()
            
            self.viewModel.getAll(startDate: startDate, endDate: endDate)
        }
        .sheet(isPresented: $showingAddDialog) {
            AddScheduleView(showingDialog: $showingAddDialog) {
                self.viewModel.getAll(startDate: startDate, endDate: endDate)
            }
            .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingEditDialog) {
            EditScheduleView(showingDialog: $showingEditDialog, schedule: self.selectedScheduleViewData!) {

            }
            .environmentObject(viewModel)
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("DELETE".localized),
                message: Text("DELETE_ITEM_MSG".localized),
                primaryButton: .destructive(Text("DELETE".localized)) {

                    viewModel.remove(at: itemPosition!, from: dateGroupToDelete)
                },
                secondaryButton: .cancel {

                }
            )
        }
        .actionSheet(isPresented: $showingDeleteConfirmation) {
            ActionSheet(
                title: Text("DELETE".localized),
                message: Text("DELETE_ITEM_MSG".localized),
                buttons: [
                    .destructive(Text("DELETE".localized)) {
                        viewModel.remove(at: itemPosition!, from: dateGroupToDelete)
                    },
                    .cancel()
                ]
            )
        }
        .onChange(of: selectedScheduleViewData) { newValue in
            if let schedule = newValue {
                self.selectedScheduleViewData = schedule
                self.showingEditDialog = true
            }
        }

    }
    
    
    private func deleteCategory(at offsets: IndexSet, date: String) {
        self.showingDeleteConfirmation = true
        self.itemPosition = offsets.first!
        self.dateGroupToDelete = date
        
    }
    
    func getColorAndText(completed: Bool) -> (color: Color, text: String) {
        if (completed) {
            return (Color.green, "CONCLUDED".localized)
        }
        
        return (Color.yellow, "OPEN".localized)
    }
    
}
