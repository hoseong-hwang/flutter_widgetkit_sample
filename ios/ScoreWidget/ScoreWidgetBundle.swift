//
//  ScoreWidgetBundle.swift
//  ScoreWidget
//
//  Created by ppbstudios on 5/19/25.
//

import WidgetKit
import SwiftUI

@main
struct ScoreWidgetBundle: WidgetBundle {
    var body: some Widget {
//        ScoreWidget()
        if #available(iOS 16.1, *) {
            ScoreWidgetLiveActivity()
        }
    }
}
