//
//  ClassroomTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/14/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ClassroomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    /// Once this variable is set, the label will change
    internal var name: String? {
        didSet {
            self.nameLabel.text = name
            if name != oldValue{
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
