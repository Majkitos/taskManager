//
//  NotificationsManager.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/21/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreData

class NotificationsManager {
    
    static let sharedInstance = NotificationsManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func newNotification(date: Date, uuid: String, body: String) {
        
    delegate?.scheduleNotification(
        atDate: date,
        title: "You have something to do, remember?",
        body: body,
        uuid: uuid)
    }
    
    func unscheduleAllNotifications() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func rescheduleAllNotifications() {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                
                if task.notificationEnabled == true {
    
                    //schedule notification
                    newNotification(date: task.date, uuid: task.uuid!, body: task.taskDescription!)
                }
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
