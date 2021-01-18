//
//  planWidget.swift
//  planWidget
//
//  Created by User22 on 2021/1/12.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), plan: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), plan: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        var plan = ""
        let userDefault = UserDefaults(suiteName: "group.tina.plan")
        if let messages = userDefault?.string(forKey: "myPlan"){
            plan = String(messages)
            print(messages)
        }
        else{
            print("qqqqqqq")
            plan = "還沒有出去玩的行程"
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let entry = SimpleEntry(date: Date(), plan: plan)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var plan: String
}

struct planWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        Text(entry.plan)
    }
}

@main
struct planWidget: Widget {
    let kind: String = "planWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            planWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct planWidget_Previews: PreviewProvider {
    static var previews: some View {
        planWidgetEntryView(entry: SimpleEntry(date: Date(), plan: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
