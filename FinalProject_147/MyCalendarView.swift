//
//  MyCalendarView.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/8.
//

import SwiftUI

struct MyCalendarView: View {
    
    @Environment(\.calendar) var calendar
    @State var showingDayView = true
    @State var components = DateComponents()
    
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    @State private var myColor = Color(red: 255/255, green: 218/255, blue: 220/255)
    
    var body: some View {
        
        VStack{
            CalendarView(interval: self.year) { date in
                Text("30")
                    .hidden()
                    .padding(8)
                    .background(myColor)
                    .clipShape(Rectangle())
                    .cornerRadius(4)
                    .padding(4)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date)))
                            .foregroundColor(Color.black)
                    )
                    .onTapGesture{
                        self.showingDayView = true
                        self.components.month = self.calendar.component(.month, from: date)
                        self.components.day = self.calendar.component(.day, from: date)
                        self.components.year = self.calendar.component(.year, from: date)
                        //myColor = Color(red: 255/255, green: 218/255, blue: 220/255)
                    }
                /*.sheet(isPresented: self.$showingDayView) {
                 DayView(date: self.calendar.date(from: self.components) ?? Date())
                 }*/
            }
            
            if(showingDayView){
                DayView(date: self.calendar.date(from: self.components) ?? Date())
            }
            
        }
    }
    
}







fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    @ObservedObject var timePlusDestData = TimePlusDestData()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                        
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State private var month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    
    init(
        month: Date,
        showHeader: Bool = true,
        localizedWeekdays: [String] = [],
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
        self.showHeader = showHeader
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date
        }
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return HStack{
            Text(formatter.string(from: month))
                .font(.title)
                .padding(.horizontal)
            Spacer()
            HStack{
                Group{
                    Button(action: {
                        self.changeDateBy(-1)
                    }) {
                        Image(systemName: "chevron.left.square") //
                            .resizable()
                    }
                    Button(action: {
                        self.month = Date()
                    }) {
                        Image(systemName: "dot.square")
                            .resizable()
                    }
                    Button(action: {
                        self.changeDateBy(1)
                    }) {
                        Image(systemName: "chevron.right.square") //"chevron.right.square"
                            .resizable()
                    }
                }
                .foregroundColor(Color.blue)
                .frame(width: 25, height: 25)
                
            }
            .padding(.trailing, 20)
        }
    }
    
    var body: some View {
        VStack {
            if showHeader {
                header
            }
            HStack{
                ForEach(0..<7, id: \.self) {index in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .clipShape(Circle())
                        .padding(.horizontal, 4)
                        .overlay(
                            Text(getWeekDaysSorted()[index].uppercased()))
                }
            }
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            // left
                            self.changeDateBy(1)
                        }
                        
                        if value.translation.width > 0 {
                            // right
                            self.changeDateBy(-1)
                        }
                    }))
        .animation(.default)
    }
    
    func getWeekDaysSorted() -> [String]{
        let weekDays = Calendar.current.shortWeekdaySymbols
        let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
        return sortedWeekDays
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        
        ForEach(months, id: \.self) { month in
            MonthView(month: month, content: self.content)
        }
        
    }
}
