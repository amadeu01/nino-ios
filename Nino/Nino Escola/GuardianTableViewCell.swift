//
//  GuardianTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/19/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardianTableViewCell: StandardManagementTableViewCell {
    
    @IBOutlet weak var guardianNameLabel: UILabel!
    /// Once this variable is set, the label will change
    
    @IBOutlet weak var guardianProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel = guardianNameLabel
        self.profileImageView = guardianProfileImageView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
