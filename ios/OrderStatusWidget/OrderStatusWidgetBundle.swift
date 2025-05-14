//
//  OrderStatusWidgetBundle.swift
//  OrderStatusWidget
//
//  Created by ppbstudios on 5/14/25.
//

import WidgetKit
import SwiftUI

@main
struct OrderStatusWidgetBundle: WidgetBundle {
    var body: some Widget {
//        OrderStatusWidget()
        if #available(iOS 16.1, *) {
            OrderStatusWidgetLiveActivity()
        }    }
}
