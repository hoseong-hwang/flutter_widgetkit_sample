//
//  StepWidgetBundle.swift
//  StepWidget
//
//  Created by ppbstudios on 5/23/25.
//

import WidgetKit
import SwiftUI

@main
struct StepWidgetBundle: WidgetBundle {
    var body: some Widget {
        //        StepWidget()
        if #available(iOS 16.1, *) {
            StepWidgetLiveActivity()
        }
    }
}
