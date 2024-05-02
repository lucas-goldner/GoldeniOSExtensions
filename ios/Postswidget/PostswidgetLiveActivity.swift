//
//  PostswidgetLiveActivity.swift
//  Postswidget
//
//  Created by Lucas Goldner on 02.05.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PostswidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PostswidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PostswidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PostswidgetAttributes {
    fileprivate static var preview: PostswidgetAttributes {
        PostswidgetAttributes(name: "World")
    }
}

extension PostswidgetAttributes.ContentState {
    fileprivate static var smiley: PostswidgetAttributes.ContentState {
        PostswidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PostswidgetAttributes.ContentState {
         PostswidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PostswidgetAttributes.preview) {
   PostswidgetLiveActivity()
} contentStates: {
    PostswidgetAttributes.ContentState.smiley
    PostswidgetAttributes.ContentState.starEyes
}
