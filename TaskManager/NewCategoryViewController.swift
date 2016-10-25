//
//  NewCategoryViewController.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/20/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewControllerLabel: UINavigationItem!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Edit Mode
    
    var editMode = false
    var categoryToEdit: Category?
    var x: CGFloat?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        x = (view.bounds.width - 20)/14
        
        textField.delegate = self
        
        var buttonFrame = CGRect(
            x: 1.5*x!,
            y: 245,
            width: x!,
            height: x!)
        var i:CGFloat = 1.0
        
        while i > 0 {
            self.colorPicker(buttonFrame: buttonFrame, sat: i ,bright: 1.0)
            i = i - 0.1
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        
         // Edit Mode
        if editMode == true {
            
            navItem.title = "Edit Category"
            textField.text = categoryToEdit?.category
            categoryButton.setTitle(categoryToEdit?.category, for: .normal)
            categoryButton.backgroundColor = categoryToEdit?.color as! UIColor?
        }
    }

    // Color Picker
    
    func colorPicker(buttonFrame:CGRect, sat:CGFloat, bright:CGFloat){
        
        var myButtonFrame = buttonFrame
        for i in 0..<12 {
            let hue:CGFloat = CGFloat(i) / 12.0
            let color = UIColor(
                hue: hue,
                saturation: sat,
                brightness: bright,
                alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            view.addSubview(aButton)
            aButton.addTarget( self, action: #selector(displayColor(sender:)),for: UIControlEvents.touchUpInside)
        }
    }
    
    func displayColor(sender:UIButton){
        
        categoryButton.backgroundColor = sender.backgroundColor!
    }
    
    // text field
    
    @IBAction func newCategoryTitle(_ sender: AnyObject) {
        
        textField.resignFirstResponder()
        categoryButton.setTitle(textField.text!, for: .normal)
    }
    
    @IBAction func tapGesture(_ sender: AnyObject) {
        
        textField.resignFirstResponder()
        categoryButton.setTitle(textField.text!, for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        categoryButton.setTitle(textField.text!, for: .normal)
        
        return true
    }
    
    // Navigation
    
    @IBAction func save(_ sender: AnyObject) {
        
        if editMode == false {
            
        // Save new category Mode
        
        textField.resignFirstResponder()
        categoryButton.setTitle(textField.text!, for: .normal)
        
        if categoryButton.titleLabel?.text! != "Category" || textField.text! != "" {
           
        Categories.sharedInstance.addCategory(categoryTitle: textField.text!, color: categoryButton.backgroundColor!)
            
        _ = self.navigationController?.popViewController(animated: true)
            
    }
         } else {
            
            // Edit Mode
            
            textField.resignFirstResponder()
            categoryButton.setTitle(textField.text!, for: .normal)
            
            let index = Categories.sharedInstance.categoryAtIndex(category: categoryToEdit!)
            Categories.sharedInstance.editCategory(atIndex: index, categoryTitle: textField.text! , color: categoryButton.backgroundColor!)
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}








