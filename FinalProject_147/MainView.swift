//
//  MainView.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import SwiftUI

struct MainView: View {
    //@StateObject var weatherViewModel = WeatherViewModel()
    //@EnvironmentObject var weatherViewModel: WeatherViewModel
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var destViewModel = DestViewModel()
    @State var expand = false
    @State private var city = "基隆市";
    
    
    @State private var selectImage = Image(systemName: "photo")
    @State private var showSelectPhoto = false
    var cities = ["基隆市","臺北市","新北市","桃園市","新竹市","新竹縣","苗栗縣","臺中市","彰化縣","南投縣","雲林縣",
                  "嘉義市","嘉義縣","臺南市","高雄市","屏東縣","宜蘭縣","花蓮縣","臺東縣","澎湖縣","金門縣","連江縣"]
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func getBackImage()->UIImage{
        if let image = loadImageFromDiskWith(fileName: "image.jpg") {
            return image
        }
        return UIImage(systemName: "photo")!
    }
    @State private var backGround: UIImage = UIImage(systemName: "photo")!
    
    var body: some View {
        NavigationView{
            /*selectImage
             .resizable()
             .scaledToFill()
             .edgesIgnoringSafeArea(.all)
             .opacity(0.5)*/
            VStack{
                Button(action: {
                    showSelectPhoto = true
                }){
                    Text("更換背景")
                        .frame(width: 80, height: 50)
                }
                HStack{
                    DisclosureGroup("\(city)", isExpanded: $expand){
                        ScrollView{
                            VStack{
                                ForEach(cities.indices){(index) in
                                    Text(cities[index])
                                        .onTapGesture{
                                            self.city = cities[index]
                                            self.expand.toggle()
                                        }
                                }
                            }
                            
                        }
                        .frame(width: 150, height: 150, alignment: .center)
                    }
                    NavigationLink(destination: DestListView(city: city)){
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        weatherViewModel.fetchWeathers(city: city)
                        destViewModel.fetchDests()
                    })
                }
                
                .padding(.all)
                
            }
            
            
            .background(selectImage
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5))
        }
        
        
        .environmentObject(weatherViewModel)
        .environmentObject(destViewModel)
        .onAppear{
            selectImage = Image(uiImage: getBackImage())
            destViewModel.fetchDests()
            weatherViewModel.fetchWeathers(city: "基隆市")
        }
        
        .sheet(isPresented: $showSelectPhoto){
            ImagePickerController(showSelectPhoto: $showSelectPhoto, selectImage: $selectImage)
        }
        
    }
}



