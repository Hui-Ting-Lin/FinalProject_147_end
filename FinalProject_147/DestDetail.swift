//
//  DestDetail.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/29.
//

import SwiftUI
import WidgetKit

struct DestDetail: View {
    
    func getTimeArray(times: [MyTime])->Array<String>{
        var timeArray = [String]()
        for i in Swift.stride(from: 0, to: 14, by: 2){
            let timeString = times[i].startTime
            let r = timeString.startIndex..<timeString.index(timeString.startIndex, offsetBy: 10)
            let result = timeString[r]
            timeArray.append(String(result))
        }
        return timeArray
    }
    func getRainArray(times: [MyTime])->Array<String>{
        var rainArray = [String]()
        for i in Swift.stride(from: 0, to: 14, by: 2){
            if(times[i].elementValue[0].value==" "){
                rainArray.append(String(Int.random(in: 0...10)*10))
            }
            else{
                rainArray.append(times[i].elementValue[0].value)
            }
        }
        
        return rainArray
    }
    func getLowArray(times: [MyTime])->Array<String>{
        var lowArray = [String]()
        for i in Swift.stride(from: 0, to: 14, by: 2){
            lowArray.append(times[i].elementValue[0].value)
        }
        return lowArray
    }
    func getHighArray(times: [MyTime])->Array<String>{
        var highArray = [String]()
        for i in Swift.stride(from: 0, to: 14, by: 2){
            highArray.append(times[i].elementValue[0].value)
        }
        return highArray
    }
    
    func getGoodDay(rainArray: [String])->[Bool]{
        var goodDay = [false, false, false, false, false, false, false]
        var bestIndex = 0
        for i in 1..<7{
            if(Int(rainArray[i]) ?? 0<=Int(rainArray[bestIndex]) ?? 0){
                bestIndex = i;
            }
        }
        goodDay[bestIndex] = true
        return goodDay
    
    }
    
    
    
    var destination: TravelDest
    @ObservedObject var timePlusDestData = TimePlusDestData()
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var rainArray = ["","","","","","",""]
    @State private var goodDay = [false, false, false, false, false, false, false]
    @StateObject var selectedDate = TimeString()
    @State private var showAlert = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        //Text(destViewModel.travelDest[1].Region)
        VStack{
            WeekWeatherView(time: getTimeArray(times: weatherViewModel.locationWeather.weatherElement[1].time),
                            rainRate: rainArray,
                            lowTemp:getLowArray(times: weatherViewModel.locationWeather.weatherElement[8].time),
                            highTemp:getHighArray(times: weatherViewModel.locationWeather.weatherElement[12].time),
                            goodDay: getGoodDay(rainArray: rainArray))
            .onAppear{
                rainArray = getRainArray(times: weatherViewModel.locationWeather.weatherElement[0].time)
            }
            Text(destination.Name!)
            
            ImageView(urlString: destination.Picture1 ?? "")
            
            Text("地址：\(destination.Add!)")
            Text("電話：\(destination.Tel!)")
            HStack{
                Text("網址：")
                if(destination.Website==""){
                    Text("無")
                }
                else{
                    Link("here", destination: URL(string: destination.Website!)!)
                }
                
            }
            ScrollView{
                VStack{
                    Text("詳細資料：")
                    Text(destination.Description ?? "")
                }
            }
            HStack{
                LottieView(filename: "TwitterHeartButton")
                    .frame(width: 50, height: 50)
                    Button("加到行事曆"){
                        showAlert = true
                    let timeDest = TimePlusDest(time: selectedDate.time, travelDest: destination)
                    timePlusDestData.timePlusDests.insert(timeDest, at: 0)
                    
                    let newPlan = Plan(context: viewContext)
                    newPlan.creatAt = Date()
                    newPlan.time = timeDest.time
                    newPlan.destination = timeDest.travelDest.Name
                        
                    //存到userDefault來和widget共用

                    let userDefault = UserDefaults(suiteName: "group.tina.plan")
                        userDefault?.set("\(timeDest.time) \(destination.Name!)", forKey: "myPlan")
                    WidgetCenter.shared.reloadAllTimelines()
                    //"\(timeDest.time)\(timeDest.travelDest.Name)"
                        
                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
                .alert(isPresented: $showAlert) { () -> Alert in
                        return Alert(title:Text("已成功加入行事曆！"))
                }
                LottieView(filename: "TwitterHeartButton")
                    .frame(width: 50, height: 50)
            }
            
        }
        .environmentObject(selectedDate)
    }
    
    
}

struct ImageView: View{
    var urlString: String
    @State private var image = Image(systemName: "photo")
    @State private var downloadImageOK = false
    func getImage(){
        if urlString != ""{
            if let url = URL(string: urlString){
                URLSession.shared.dataTask(with: url){ (data, response, error) in
                    if let data = data, let uiImage = UIImage(data: data){
                        image = Image(uiImage: uiImage)
                        downloadImageOK = true
                    }
                }.resume()
                
            }
        }
    }
    var body: some View{
        image
            .resizable()
            .frame(width: 300, height: 200)
            .onAppear{
                if (downloadImageOK==false){
                    getImage()
                }
            }
    }
    
}

struct WeekWeatherView: View {
    var time: [String]
    var rainRate: [String]
    var lowTemp: [String]
    var highTemp: [String]
    var goodDay: [Bool]
    var selectDayColor = Color(red: 252/255, green: 185/255, blue: 178/255)
    @EnvironmentObject var selectedDate: TimeString
    @State private var selectTime = ""
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(0..<lowTemp.count) { (index) in
                    DayWeatherView(time: time[index], rainRate: rainRate[index], lowTemp: lowTemp[index], highTemp: highTemp[index], goodDay: goodDay[index], selectTime: selectTime)
                        .onTapGesture{
                            self.selectTime = time[index]
                            selectedDate.time = selectTime
                        }
                        
                }
                .onAppear{
                    var dateFormatter: DateFormatter {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        return formatter
                    }
                    
                    self.selectedDate.time = dateFormatter.string(from: Date())
                    selectTime = dateFormatter.string(from: Date())
                }
                
            }
        }
    }
}


struct DayWeatherView: View {
    
    var time: String
    var rainRate: String
    var lowTemp: String
    var highTemp: String
    var goodDay: Bool
    var selectTime: String
    
    var body: some View {
        
        ZStack{
            if(goodDay){
                Rectangle()
                    .foregroundColor(Color(red: 172/255, green: 252/255, blue: 271/255))
                    .frame(width: 120, height: 120, alignment: .center)
            }
            else{
                Rectangle()
                    .foregroundColor(Color(red: 255/255, green: 238/255, blue: 190/255))
                    .frame(width: 120, height: 120, alignment: .center)
            }
            if(selectTime==time){
                Rectangle()
                    .foregroundColor(Color(red: 252/255, green: 185/255, blue: 178/255))
                    .frame(width: 120, height: 120, alignment: .center)
            }
            VStack{
                Text(time)
                Image(systemName: "cloud.rain")
                
                Text("降雨機率: \(rainRate)%")
                Text("攝氏\(lowTemp)~\(highTemp)度")
            }
            
        }
        
        
    }
}


