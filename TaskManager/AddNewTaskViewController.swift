//
//  AddNewTaskViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

struct TaskDescription {
    static var text = ""
    static var notificationDate: Date?
}

class AddNewTaskViewController: UIViewController, UITextFieldDelegate {
    
    var comingFromCategories = false
    
    var selectedCategory = 0
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTextField.delegate = self
        taskTextField.text = TaskDescription.text
        
        if comingFromCategories == true {
        
            datePickerOutlet.date = TaskDescription.notificationDate!
        } else {
            todaysDate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let category = Categories.sharedInstance.categories[Int(selectedCategory)]
        categoryButton.setTitle(category.category, for: .normal)
        categoryButton.backgroundColor = category.color as! UIColor?
    }
    
    func todaysDate() {
        
        let date = Date()
        TaskDescription.notificationDate = date
        
    }
    
    @IBAction func datePicker(_ sender: AnyObject) {
        
        TaskDescription.notificationDate = datePickerOutlet.date
    }
    
    @IBAction func categoryButton(_ sender: AnyObject) {
        
        taskTextField.resignFirstResponder()
        TaskDescription.text = taskTextField.text!
        
        self.performSegue(withIdentifier: "newTask", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        taskTextField.resignFirstResponder()
        TaskDescription.text = taskTextField.text!
        
        return true
    }
    
    @IBAction func tapGesture(_ sender: AnyObject) {
        
        taskTextField.resignFirstResponder()
        TaskDescription.text = taskTextField.text!
    }
    
    @IBAction func save(_ sender: AnyObject) {
        
        taskTextField.resignFirstResponder()
        TaskDescription.text = taskTextField.text!
        
        if TaskDescription.text != "" && TaskDescription.notificationDate != nil {
        
            let uuid = UUID().uuidString
        // Creat and save new task
            Tasks.sharedInstance.addTask(description: TaskDescription.text, date: TaskDescription.notificationDate!, finished: false, category: selectedCategory, uuid: uuid)
            
        // Schedule notification
          
            NotificationsManager.sharedInstance.newNotification(date: TaskDescription.notificationDate!, uuid: uuid, body: TaskDescription.text)
            
            goToInitialView()
            
        } 
    }
    
    @IBAction func Cancel(_ sender: AnyObject) {
        
        goToInitialView()
    }

    //MARK: Navigation
    
    func goToInitialView() {
        
        TaskDescription.text = ""
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "initialView") as! InitialViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == "newTask" {
            
            let dvc = segue.destination as! CategoriesTableViewController
            dvc.comingFromView = "newTask"
        }
    }
}
