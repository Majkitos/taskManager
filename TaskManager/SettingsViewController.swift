//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/19/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var filterController: UISegmentedControl!
    @IBOutlet weak var notificationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingsData.sharedInstance.getSettingsData()
        
        if SettingsData.sharedInstance.settings[0].sortedBy == "date" {
        filterController.selectedSegmentIndex = 0
        } else if SettingsData.sharedInstance.settings[0].sortedBy == "name" {
        filterController.selectedSegmentIndex = 1
        }
        
        if SettingsData.sharedInstance.settings[0].notifcationsEnabled == true {
            
            notificationSwitch.setOn(true, animated: true)
            
        } else if SettingsData.sharedInstance.settings[0].notifcationsEnabled == false {
            
            notificationSwitch.setOn(false, animated: false)
        }
    }

    @IBAction func disableNotifications(_ sender: AnyObject) {
        
        if notificationSwitch.isOn {
            
            NotificationsManager.sharedInstance.rescheduleAllNotifications()
            SettingsData.sharedInstance.editSettings(NotificationsEnabled: true)
            
            
        } else {
            
            NotificationsManager.sharedInstance.unscheduleAllNotifications()
            SettingsData.sharedInstance.editSettings(NotificationsEnabled: false)
            
        }
    }

    @IBAction func filterTasks(_ sender: AnyObject) {
        
        if filterController.selectedSegmentIndex == 0 {
            
            SettingsData.sharedInstance.editSettings(SortedBy: "date")
            
        } else if filterController.selectedSegmentIndex == 1 {
            
            SettingsData.sharedInstance.editSettings(SortedBy: "name")
        }
    }
}
