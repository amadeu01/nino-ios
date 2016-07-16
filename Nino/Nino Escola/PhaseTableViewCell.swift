//
//  PhaseTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/14/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PhaseTableViewCell: UITableViewCell {

    @IBOutlet weak var phaseNameLabel: UILabel!
    /// Once this variable is set, the label will change
    internal var phaseName: String? {
        didSet {
            self.phaseNameLabel.text = phaseName
            if phaseName != oldValue {
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
