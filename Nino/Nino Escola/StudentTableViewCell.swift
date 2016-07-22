//
//  StudentTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/15/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentTableViewCell: StandardManagementTableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    /// Once this variable is set, the label will change
    
    @IBOutlet weak var studentProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel = studentNameLabel
        self.profileImageView = studentProfileImageView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
