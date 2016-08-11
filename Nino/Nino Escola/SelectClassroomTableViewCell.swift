//
//  SelectClassroomTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class SelectClassroomTableViewCell: StandardManagementTableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var classroomProfileImageView: UIImageView!
    
    /// Once this variable is set, the label will change
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView = classroomProfileImageView
        self.nameLabel = classroomNameLabel
        // Initialization code
    }

}
