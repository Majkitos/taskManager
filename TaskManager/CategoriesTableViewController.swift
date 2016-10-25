//
//  CategoriesTableViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

protocol SelectedCategoryDelegate {
    
    func categorySelected(cellID:Int)
}

class CategoriesTableViewController: UITableViewController, SelectedCategoryDelegate {
    
    var categories = [Category]()
    var comingFromView = ""
    
    var selectedCategory = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    func categorySelected(cellID:Int) {
        
        selectedCategory = cellID
        
        if comingFromView == "newTask" {
            performSegue(withIdentifier: "newCategory", sender: self)
        } else if comingFromView == "editTask" {
           performSegue(withIdentifier: "editedTask", sender: self)
        }
    }
    
    func getData() {
        
        categories = Categories.sharedInstance.getCategories()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.delegate = self
        cell.categoryButton.tag = indexPath.row

        let category = Categories.sharedInstance.categories[indexPath.row]
        cell.categoryButton.setTitle(category.category, for: .normal)
        cell.categoryButton.backgroundColor = category.color as? UIColor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == "newCategory" {
            
            let dvc = segue.destination as! AddNewTaskViewController
          
            dvc.selectedCategory = self.selectedCategory
            dvc.comingFromCategories = true
            
        } else if segue.identifier == "editedTask" {
            
            let dvc = segue.destination as! TaskDetailViewController
            
            dvc.selectedCategory = self.selectedCategory
            dvc.comingFromCategories = true
        }
    }
}








