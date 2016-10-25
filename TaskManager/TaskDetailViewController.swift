//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit
import UserNotifications

struct TaskEdit {
    
    static var oldTask: Task?
    
    static var category: Int?
    static var taskFinished = false
    static var taskDescription = ""
    static var notificationEnabled = true
    static var date: Date?
}

class TaskDetailViewController: UIViewController, UITextFieldDelegate {
    
    var task: Task!
    var comingFromCategories = false
    var selectedCategory = 0

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var leftButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comingFromCategories == false {
            
            TaskEdit.oldTask = task
            TaskEdit.date = task.date
            TaskEdit.taskFinished = task.finished
            TaskEdit.taskDescription = task.taskDescription!
            TaskEdit.category = Int(task.category)
            selectedCategory = Int(task.category)
            TaskEdit.notificationEnabled = task.notificationEnabled
        }
        
        if TaskEdit.taskFinished == true {
            
            finishedButton.setImage(UIImage(named:"finished"), for: .normal)
            taskView.backgroundColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
            descriptionTextField.backgroundColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
            TaskEdit.category = selectedCategory
        }
        
        descriptionTextField.delegate = self
        descriptionTextField.text = TaskEdit.taskDescription
        dateLabel.text = dateString(date: TaskEdit.date!)
        setDatePicker()
        
        if TaskEdit.notificationEnabled == true {
        notificationSwitch.setOn(true, animated: true)
        } else {
            notificationSwitch.setOn(false, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        TaskEdit.category = selectedCategory
        let category = Categories.sharedInstance.categories[selectedCategory]
        categoryButton.setTitle(category.category, for: .normal)
        categoryButton.backgroundColor = category.color as? UIColor
        
    }
    
    @IBAction func finishedButtonAction(_ sender: AnyObject) {
        
        if TaskEdit.taskFinished == true {
            
            finishedButton.setImage(UIImage(named:"unfinished"), for: .normal)
            taskView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 246/255.0, alpha: 1.0)
            descriptionTextField.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 246/255.0, alpha: 1.0)
            TaskEdit.taskFinished = false
            
        } else {
            
            finishedButton.setImage(UIImage(named:"finished"), for: .normal)
            taskView.backgroundColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
            descriptionTextField.backgroundColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
            TaskEdit.taskFinished = true
        }
    }
    
    @IBAction func tapGesture(_ sender: AnyObject) {
        
        descriptionTextField.resignFirstResponder()
        TaskEdit.taskDescription = descriptionTextField.text!
    }
    
    func setDatePicker() {
    
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm"
        let date = dateFormatter.date(from: TaskEdit.taskDate)
        */
        
        datePickerOutlet.date = TaskEdit.date!
    }
    
    @IBAction func changeDescription(_ sender: AnyObject) {
        
            descriptionTextField.resignFirstResponder()
            TaskEdit.taskDescription = descriptionTextField.text!
    }
    
    @IBAction func datePicker(_ sender: AnyObject) {
        
        dateLabel.text = dateString(date: datePickerOutlet.date)
        TaskEdit.date = datePickerOutlet.date
    }
    
    func dateString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
   
    @IBAction func saveButton(_ sender: AnyObject) {
        
        descriptionTextField.resignFirstResponder()
        TaskEdit.taskDescription = descriptionTextField.text!

        Tasks.sharedInstance.editTask(withUUID: (TaskEdit.oldTask?.uuid)! , description: TaskEdit.taskDescription, date: TaskEdit.date!, finished: TaskEdit.taskFinished, category: TaskEdit.category!)
        
        // Update task notification
        // Delete old scheduled notification and schedule new one
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(TaskEdit.oldTask?.uuid)!])
        NotificationsManager.sharedInstance.newNotification(date: TaskEdit.date!, uuid: (TaskEdit.oldTask?.uuid)!, body: TaskEdit.taskDescription)
        Tasks.sharedInstance.taskNotification(isEnabled: true, uuid: (TaskEdit.oldTask?.uuid)!)
        TaskEdit.notificationEnabled = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "initialView") as! InitialViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "initialView") as! InitialViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func manageNotification(_ sender: AnyObject) {
        
        if notificationSwitch.isOn {
    
            // schedule new notification
            NotificationsManager.sharedInstance.newNotification(date: TaskEdit.date!, uuid: (TaskEdit.oldTask?.uuid)!, body: TaskEdit.taskDescription)
            
            Tasks.sharedInstance.taskNotification(isEnabled: true, uuid: (TaskEdit.oldTask?.uuid)!)
            TaskEdit.notificationEnabled = true
            
        } else {
    
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(TaskEdit.oldTask?.uuid)!])
            Tasks.sharedInstance.taskNotification(isEnabled: false, uuid: (TaskEdit.oldTask?.uuid)!)
            TaskEdit.notificationEnabled = false
        }
    }
    
    @IBAction func selectCategory(_ sender: AnyObject) {
        
        descriptionTextField.resignFirstResponder()
        TaskEdit.taskDescription = descriptionTextField.text!
        
        self.performSegue(withIdentifier: "editTask", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        descriptionTextField.resignFirstResponder()
        TaskEdit.taskDescription = descriptionTextField.text!
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == "editTask" {
            
            let dvc = segue.destination as! CategoriesTableViewController
            dvc.comingFromView = "editTask"

        }
    }
}
