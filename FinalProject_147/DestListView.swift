//
//  DestListView.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/7.
//

import SwiftUI


struct DestListView: View {
    @EnvironmentObject var destViewModel: DestViewModel
    
    func getDestArray()->Array<TravelDest>{
        var destArray = [TravelDest]()
        for index in 0..<destViewModel.travelDest.count{
            if(destViewModel.travelDest[index].Region == city){
                destArray.append(destViewModel.travelDest[index])
            }
        }
        return destArray
    }
    
    func checkId(destId: [UUID], currentId: UUID)->Bool{
        for i in 0..<destId.count{
            if(currentId==destId[i]) {
                return false
            }
        }
        return true
        
    }
    
    var city: String
    @State private var destArray = [TravelDest]()
    @State private var randomDests = [TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: ""), TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: ""), TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: ""), TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: ""), TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: "")]
    @State private var first = true
    
    

    var body: some View {
        
        VStack{
            List{
                ForEach(randomDests, id: \.id){(travelDest) in
                    NavigationLink(
                        destination:DestDetail(destination: travelDest)){
                        DestRow(destination: travelDest)
                    }
                }
            }
        }
        
        
        
        
        .onAppear{
            if(first){
                destViewModel.fetchDests()
                self.destArray = getDestArray()
                first = false
                
                var destId = [UUID()]
                randomDests = [destArray.randomElement() ?? TravelDest(Name: "", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: "")]
                destId[0] = randomDests[0].id
                for _ in 0..<4{
                    var randomDest = destArray.randomElement() ?? TravelDest(Name: "123123", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: "")
                    while(!checkId(destId: destId, currentId: randomDest.id)){
                        randomDest = destArray.randomElement() ?? TravelDest(Name: "123123", Description: "", Tel: "", Add: "", Region: "", Town: "", Website: "", Picture1: "")
                    }
                    
                    randomDests.append(randomDest)
                    destId.append(randomDest.id)
                }
            }
            
        }
    }
}



struct SearchBarView: UIViewRepresentable {
    

    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: Context) {
        uiView.text = text
    }
    typealias UIViewType = UISearchBar
}

class Coordinator: NSObject, UISearchBarDelegate {

    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        text = searchText
    }
}

