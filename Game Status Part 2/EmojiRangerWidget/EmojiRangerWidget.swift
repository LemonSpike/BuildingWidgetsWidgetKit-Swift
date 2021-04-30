/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A widget that shows the avatar for a single character.
 */

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
  public typealias Entry = SimpleEntry

  func character(for configuration: CharacterSelectionIntent) -> CharacterDetail {
    switch configuration.hero {
      case .panda:
        return .panda
      case .egghead:
        return .egghead
      case .spouty:
        return .spouty
      default:
        return .panda
    }
  }

  func placeholder(in context: Context) -> SimpleEntry {
    return SimpleEntry(date: Date(), character: .panda, relevance: nil)
  }

  func getSnapshot(for configuration: CharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), character: .panda, relevance: nil)
    completion(entry)
  }

  func getTimeline(for configuration: CharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let selectedCharacter = character(for: configuration)
    let endDate = selectedCharacter.fullHealthDate
    let oneMinute: TimeInterval = 60
    var currentDate = Date()

    var entries: [SimpleEntry] = []
    while currentDate < endDate {
      let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
      let entry = SimpleEntry(date: currentDate, character: selectedCharacter, relevance: relevance)
      currentDate += oneMinute
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }

}

struct SimpleEntry: TimelineEntry {
  public let date: Date
  let character: CharacterDetail
  let relevance: TimelineEntryRelevance?
}

struct PlaceholderView: View {

  var body: some View {
    return EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .panda, relevance: nil))
      .redacted(reason: .placeholder)
  }
}

struct EmojiRangerWidgetEntryView: View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family

  var body: some View {
    switch family {
      case .systemSmall:
        ZStack {
          AvatarView(entry.character)
            .foregroundColor(.white)
        }
        .background(Color.gameBackground)
        .widgetURL(entry.character.url)
      default:
        ZStack {
          HStack(alignment:.top) {
            AvatarView(entry.character)
              .foregroundColor(.white)
            Text(entry.character.bio)
              .padding()
              .foregroundColor(.white)
          }
          .padding()
        }
        .background(Color.gameBackground)
        .widgetURL(entry.character.url)
    }
  }
}

@main
struct EmojiRangerWidget: Widget {
  private let kind: String = "EmojiRangerWidget"

  public var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: CharacterSelectionIntent.self, provider: Provider()) { entry in
      EmojiRangerWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Ranger Detail")
    .description("See your favorite ranger.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .panda, relevance: TimelineEntryRelevance(score: Float(CharacterDetail.panda.healthLevel))))
        .previewContext(WidgetPreviewContext(family: .systemMedium))

      PlaceholderView()
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
  }
}
