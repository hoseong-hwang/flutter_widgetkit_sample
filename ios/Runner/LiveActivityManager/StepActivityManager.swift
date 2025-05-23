import Foundation
import ActivityKit
import CoreMotion

@available(iOS 16.1, *)
struct StepActivityManager {
    private static let pedometer = CMPedometer()
    private static var startDate: Date = Date()
    private static var timer: Timer?
    
    static var currentActivity: Activity<StepWidgetAttributes>?

    static func start() {
        Task {
            await currentActivity?.end(dismissalPolicy: .immediate)
        }

        timer?.invalidate()
        startDate = Date()

        let attributes = StepWidgetAttributes(date: startDate)
        let initialModel = StepStateModel(
            step: 0,
            distance: 0.0,
            floorsUp: 0,
            floorsDown: 0,
            pace: 0.0
        )
        let initialState = StepWidgetAttributes.ContentState(status: initialModel)

        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                contentState: initialState,
                pushType: nil
            )
        } catch {
            print("Live Activity 시작 실패: \(error)")
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            Task {
                await update()
            }
        }
    }

    static func update() async {
        pedometer.queryPedometerData(from: startDate, to: Date()) { data, error in
            guard let data = data, error == nil else { return }

            let updatedState = StepStateModel(
                step: data.numberOfSteps.intValue,
                distance: data.distance?.doubleValue ?? 0.0,
                floorsUp: data.floorsAscended?.intValue ?? 0,
                floorsDown: data.floorsDescended?.intValue ?? 0,
                pace: data.averageActivePace?.doubleValue ?? 0.0
            )
            print(updatedState)

            let contentState = StepWidgetAttributes.ContentState(status: updatedState)

            Task {
                await currentActivity?.update(using: contentState)
            }
        }
    }

    static func end() {
        timer?.invalidate()
        timer = nil

        Task {
            await currentActivity?.end(dismissalPolicy: .immediate)
        }
    }
}
