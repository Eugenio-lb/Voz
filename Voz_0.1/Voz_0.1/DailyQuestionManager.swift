//
//  DailyQuestionManager.swift
//  Voz
//
//  Created by Eugenio Lozano on 12/12/24.
//

import Foundation
import UserNotifications

class DailyQuestionManager{
    // Where the daily question will be stored in
    let dailyQuestion = "How are you feeling today"
    
    private let answeredKey = "answeredDateKey"
    
    // Function that asks the ser for notification permissions.
    func requestNotificationAuthorization(completion: @escaping (Bool) ->Void) {
        let notificationCenter = UNUserNotificationCenter.current() //Gives access to the notification center which manages notification-related tasks
        
        //Next line refers to asking the uer permission to send alers and sounds.
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            //This conditional checks if the user authorized notifications.
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            completion(granted)
        }
    }
    
    func scheduleDailyQuestion(){
        //Picks a random hour and minute for the notification schedule.
        let randomHour = Int.random(in:0...23)
        let randomMinute = Int.random(in:0...59)
        
        //The date components of hour and minute are set to the ones that are randomly chosen.
        var dateComponents = DateComponents()
        dateComponents.hour = randomHour
        dateComponents.minute = randomMinute
        
        //Defines the look and sound of the notification.
        let content = UNMutableNotificationContent()
        content.title = "The daily question is here!"
        content.body = dailyQuestion
        content.sound = .default
        
        //This trigger schedules the notification based on the date components setbefore and repeats: true means that it will be triggered daily, not just once.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        //Tie together the content and the trigger. The identifier makes it distinguish from other notifications, in this case it's  "dailyQuestionNotification".
        let request = UNNotificationRequest(identifier: "dailyQuestionNotification", content:content, trigger: trigger)
        
        
        //The next line asks the system to schedule the notification. Also checks if there is an error or not. And the format %02d ensures that the minutes are printed as double digits and not single 05 instead of 5.
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily question: \(error)")
            }else {
                print("Daily question scheduled at \(randomHour):\(String(format: "%02d", randomMinute))")
            }
            
        }

    }
    
    func hasAnsweredToday() -> Bool {
        let defaults = UserDefaults.standard
        guard let answeredDate = defaults.object(forKey: answeredKey) as? Date else{
            return false
        }
        let calendar = Calendar.current
        return calendar.isDateInToday(answeredDate)
    }
    
    func markAsAnswered() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: answeredKey)
    }
    
}


