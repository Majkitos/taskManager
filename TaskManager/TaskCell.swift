//
//  TaskCell.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/5/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    var delegate: TaskFinishedDelegate?
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        delegate?.taskFinished(cellId: sender.tag)
    }
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var category: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
