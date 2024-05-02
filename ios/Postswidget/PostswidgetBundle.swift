//
//  PostswidgetBundle.swift
//  Postswidget
//
//  Created by Lucas Goldner on 02.05.24.
//

import WidgetKit
import SwiftUI

@main
struct PostswidgetBundle: WidgetBundle {
    var body: some Widget {
        Postswidget()
        PostswidgetLiveActivity()
    }
}
