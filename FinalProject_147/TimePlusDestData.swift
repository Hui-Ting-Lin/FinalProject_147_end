//
//  TravelDestData.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/8.
//


import SwiftUI
class TimePlusDestData: ObservableObject {
    @AppStorage("timePlusDests") var timePlusDestData: Data?
    
    init(){
        if let timePlusDestData = timePlusDestData{
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([TimePlusDest].self, from: timePlusDestData){
                timePlusDests = decodedData
            }
        }
        
        
    }
    
    @Published var timePlusDests = [TimePlusDest](){
        didSet{
            let encoder = JSONEncoder()
            do{
                let data = try encoder.encode(timePlusDests)
                timePlusDestData = data
            } catch{
                
            }
        }
        
    }
    var number = 0
    
}


