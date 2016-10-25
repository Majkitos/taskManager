//
//  MainViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/5/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit
import UserNotifications

protocol TaskFinishedDelegate {
    
    func taskFinished(cellId: Int)
}

class MainViewController: UITableViewController,TaskFinishedDelegate {

    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         getData()
    }

    func getData() {
        
        // get task data
        tasks = Tasks.sharedInstance.tasksData()
        
        // Setting sorted by
        
        SettingsData.sharedInstance.getSettingsData()
        
        if SettingsData.sharedInstance.settings[0].sortedBy == "name" {
        
        tasks = tasks.sorted { $0.taskDescription! < $1.taskDescription! }
            
        } else if SettingsData.sharedInstance.settings[0].sortedBy == "date" {
        tasks = tasks.sorted { $0.date < $1.date }
        }
        
        // get categories data
        _ = Categories.sharedInstance.getCategories()
        
        self.tableView.reloadData()
    }

    func taskFinished(cellId: Int) {
        
        let isFinished = tasks[cellId].finished
        
        if isFinished == true {
            //Update task with UUID
            Tasks.sharedInstance.updateTask(uuid:tasks[cellId].uuid!, isFinished: false)
        } else {

            //Update task with UUID
            Tasks.sharedInstance.updateTask(uuid:tasks[cellId].uuid!, isFinished: true)
        }
        getData()
    }
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if tasks.count == 0 {
            
            let noDataLabel: UILabel     =  UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text             = "Captain's Log, Stardate 43125.8. My tasks for today are..."
            noDataLabel.textColor        = UIColor.gray
            noDataLabel.textAlignment    = .center
            noDataLabel.numberOfLines    = 3
            tableView.backgroundView = noDataLabel
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.delegate = self
        cell.doneButton.tag = indexPath.row
        
        // crossed out description
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: tasks[indexPath.row].taskDescription!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
        if tasks[indexPath.row].finished == false {
            
        cell.doneButton.setImage(UIImage(named:"unfinished"), for: .normal)
        cell.backGroundView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 246/255.0, alpha: 1.0)
        cell.taskDescription.text = tasks[indexPath.row].taskDescription

        } else {
        
        cell.taskDescription.attributedText = attributeString
        cell.doneButton.setImage(UIImage(named:"finished"), for: .normal)
        cell.backGroundView.backgroundColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
        }
        
        let index = tasks[indexPath.row].category
        let category = Categories.sharedInstance.categories[Int(index)]
        cell.category.setTitle(category.category, for: .normal)
        cell.category.backgroundColor = category.color as? UIColor
    
        cell.dateLabel.text = dateString(date: tasks[indexPath.row].date)
        
        return cell
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
                // delete task
                let task = tasks[indexPath.row]
                Tasks.sharedInstance.removeTask(withUUID: task.uuid!)
            
                //animation
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                getData()
        }
    }
    
    func dateString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    // Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "taskDetail"){
            
            let cell = sender as? TaskCell
            let indexPath = tableView.indexPath(for: cell!)
            
            let item: Task
            item = self.tasks[indexPath!.row]
            
            let dvc = segue.destination as! TaskDetailViewController
            dvc.task = item
            }
        }
}








