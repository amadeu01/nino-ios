//
//  StudentTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/15/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    /// Once this variable is set, the label will change
    internal var name: String? {
        didSet {
            self.studentNameLabel.text = name
            if name != oldValue {
                //TODO: Change Picture when old value changes
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}