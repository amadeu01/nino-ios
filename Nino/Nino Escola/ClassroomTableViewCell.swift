//
//  ClassroomTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/14/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ClassroomTableViewCell: StandardManagementTableViewCell {

    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var classroomProfileImageView: UIImageView!
    
    /// Once this variable is set, the label will change

    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView = classroomProfileImageView
        self.nameLabel = classroomNameLabel
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
