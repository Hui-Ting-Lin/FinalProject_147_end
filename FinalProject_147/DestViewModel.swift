//
//  DestViewModel.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import SwiftUI

class DestViewModel: ObservableObject {
    
    @Published var travelDest = [TravelDest]()
    
    func fetchDests() {
        if let urlStr = "https://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr)
            {
            URLSession.shared.dataTask(with: url) { (data, response ,
                                                     error) in
                let decoder = JSONDecoder()
                if let data = data,
                   let destResult = try?
                    decoder.decode(DestResult.self, from: data) {
                    //print("2")
                    DispatchQueue.main.async {
                        self.travelDest = destResult.XML_Head.Infos.Info;
                    }//把東西加到main queue
                    
                    print("fetch Travel Destination success")
                    //print(self.travelDest)
                    //print(self.travelDest[0].Region)

                    
                }
                else{print("cryyyy")}
            }.resume()
            
            
        }
    }
}

