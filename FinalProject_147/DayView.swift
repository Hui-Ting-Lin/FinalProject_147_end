//
//  DayView.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/8.
//

import SwiftUI

struct DayView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var timePlusDestData = TimePlusDestData()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    private var plans: FetchedResults<Plan>
    var date: Date
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        VStack {
            Text(self.dateFormatter.string(from: self.date))
            List {
                ForEach(plans.indices, id: \.self) { (index) in
                    if(self.dateFormatter.string(from: self.date)==plans[index].time){
                        HStack{
                            Text(plans[index].destination!)
                        }
                    }
                        
                }
                .onDelete{(indexSet) in
                    //timePlusDestData.timePlusDests.remove(atOffsets: indexSet)
                    deleteItems(offsets: indexSet)
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

