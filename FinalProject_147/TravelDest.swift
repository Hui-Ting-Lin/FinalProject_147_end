//
//  TravelDest.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//


import Foundation

struct DestResult: Codable, Identifiable{
    let id = UUID()
    let XML_Head: XMLinner
}

struct XMLinner: Codable, Identifiable {
    let id = UUID()
    let Infos: Infos
}

struct Infos: Codable, Identifiable {
    let id = UUID()
    let Info: [TravelDest]
}

struct TravelDest: Codable, Identifiable{
    let id = UUID()
    let Name: String?
    let Description: String?
    let Tel: String?
    let Add: String?
    let Region: String?
    let Town: String?
    let Website: String?
    let Picture1: String?
}



