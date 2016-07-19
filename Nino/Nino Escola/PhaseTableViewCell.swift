//
//  PhaseTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/14/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PhaseTableViewCell: StandardManagementTableViewCell {

    @IBOutlet weak var phaseNameLabel: UILabel!
    /// Once this variable is set, the label will change
    
    @IBOutlet weak var phaseProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel = phaseNameLabel
        self.profileImageView = phaseProfileImageView
    }
   
}
