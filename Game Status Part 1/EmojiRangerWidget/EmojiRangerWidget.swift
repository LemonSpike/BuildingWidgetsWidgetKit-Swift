//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by Pranav Kasetti on 23/02/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), character: .panda)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let entry = SimpleEntry(date: Date(), character: .panda)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      let entries: [SimpleEntry] = [SimpleEntry(date: Date(), character: .panda)]

      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let character: CharacterDetail
}

struct EmojiRangerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
      AvatarView(entry.character)
    }
}

@main
struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EmojiRangerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Emoji Ranger Detail")
        .description("Keep track of your favourite Emoji Ranger.")
    }
}

struct EmojiRangerWidget_Previews: PreviewProvider {
    static var previews: some View {
      AvatarView(.panda)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
