//
//  DestRow.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/7.
//

import SwiftUI

struct DestRow: View {
    var destination: TravelDest
    var body: some View {
        HStack{
            ImageView(urlString: destination.Picture1 ?? "")
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
            VStack(alignment: .leading){
                Text(destination.Name!)
                Text("\(destination.Add!)")
            }
        }
    }
}

struct DestRow_Previews: PreviewProvider {
    static var previews: some View {
        DestRow(destination: TravelDest(Name: "8787", Description: "far away", Tel: "0987878787", Add: "台北市８７路", Region: "台北", Town: "87", Website: "http://87", Picture1: "無"))
    }
}
