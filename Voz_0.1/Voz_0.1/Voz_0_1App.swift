import SwiftUI
import AVFoundation
import UserNotifications

@main
struct VozApp: App {
    let dailyQuestionManager = DailyQuestionManager()

    init() {
        // Request notification authorization
        let manager = dailyQuestionManager
        manager.requestNotificationAuthorization { granted in
            if granted {
                print("Notification authorization granted.")
                manager.scheduleDailyQuestion()
            } else {
                print("Notification authorization not granted.")
            }
        }
        
        // Request microphone access on app launch
        requestMicrophonePermission()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

    func requestMicrophonePermission() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted.")
                } else {
                    print("Microphone permission denied.")
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted.")
                } else {
                    print("Microphone permission denied.")
                }
            }
        }
    }
}
