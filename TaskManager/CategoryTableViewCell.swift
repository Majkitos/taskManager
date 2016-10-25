//
//  CategoryTableViewCell.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    var delegate: SelectedCategoryDelegate?
    @IBOutlet weak var categoryButton: UIButton!
    @IBAction func categoryButtonAction(_ sender: AnyObject) {
        delegate?.categorySelected(cellID:sender.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
