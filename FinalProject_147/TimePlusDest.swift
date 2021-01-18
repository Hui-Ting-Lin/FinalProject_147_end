//
//  TimePlusDest.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/8.
//

import Foundation

struct TimePlusDest: Codable, Identifiable{
    let id = UUID()
    let time: String
    let travelDest: TravelDest
    
}
