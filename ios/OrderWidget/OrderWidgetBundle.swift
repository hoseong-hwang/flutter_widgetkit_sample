//
//  OrderWidgetBundle.swift
//  OrderWidget
//
//  Created by ppbstudios on 5/21/25.
//

import WidgetKit
import SwiftUI

@main
struct OrderWidgetBundle: WidgetBundle {
    var body: some Widget {
//        OrderWidget()
        if #available(iOS 16.1, *) {
            OrderWidgetLiveActivity()
        }
    }
}
