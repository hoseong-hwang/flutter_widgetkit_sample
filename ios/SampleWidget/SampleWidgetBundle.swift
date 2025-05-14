//
//  SampleWidgetBundle.swift
//  SampleWidget
//
//  Created by TYGER on 5/15/25.
//

import WidgetKit
import SwiftUI

@main
struct SampleWidgetBundle: WidgetBundle {
    var body: some Widget {
//        SampleWidget()
        if #available(iOS 16.1, *) {
            SampleWidgetLiveActivity()
        }
    }
}
