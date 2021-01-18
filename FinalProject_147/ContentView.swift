//
//  ContentView.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var searchText = ""
    @ObservedObject var timePlusDestData = TimePlusDestData()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    
    private var plans: FetchedResults<Plan>
    var body: some View {
        TabView{
            MainView()
                .tabItem{
                    Image(systemName: "plus.magnifyingglass")
                }
            MyCalendarView()
                .tabItem{
                    Image(systemName: "calendar")
                }
            VStack{
                SearchBarView(text: $searchText, placeholder: "Type here")
                List {
                    Section(header: Text("Plan List"))
                    {
                    
                        ForEach(plans.filter({searchText.isEmpty ? true :    ("\($0.time) \($0.destination!)").contains(searchText)}), id: \.id){(plan) in
                            Text("\(plan.time!) \(plan.destination!)")
                        }
                        .onDelete{(indexSet) in
                            timePlusDestData.timePlusDests.remove(atOffsets: indexSet)
                            deleteItems(offsets: indexSet)
                        }
                    }
                }
            }
            .tabItem{
                Image(systemName: "list.bullet.rectangle")
            }
            
            
        }
        
        
    }
    
    private func addItem() {
        withAnimation {
            for index in 0..<timePlusDestData.timePlusDests.count {
                let newPlan = Plan(context: viewContext)
                newPlan.creatAt = Date()
                newPlan.time = timePlusDestData.timePlusDests[index].time
                newPlan.destination = timePlusDestData.timePlusDests[index].travelDest.Name
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
            }
            
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { plans[$0] }.forEach(viewContext.delete)
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
