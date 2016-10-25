//
//  EditCategoriesTableViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/19/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

class EditCategoriesTableViewController: UITableViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
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
        
        cell.categoryButton.setTitle(categories[indexPath.row].category, for: .normal)
        cell.categoryButton.backgroundColor = categories[indexPath.row].color as? UIColor
        
        return cell
    }
    
    // Navigation
    
    @IBAction func back(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "categoryDetail"){
            
            let cell = sender as? CategoryTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            
            let item: Category
            item = self.categories[indexPath!.row]
            
            let dvc = segue.destination as! NewCategoryViewController
            dvc.editMode = true
            dvc.categoryToEdit = item
        }
    }
}
