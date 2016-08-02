//
//  StandardManagementTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/16/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StandardManagementTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel?
    var profileImageView: UIImageView?
    internal var profileImage: UIImage? 
    internal var index = 0
    /// Once this variable is set, the label will change
    internal var name: String? {
        didSet {
            
            guard let nameLabel = nameLabel else {
                return
            }
            nameLabel.text = name
            if name != oldValue {
                //TODO: Change Picture when old value changes
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }
    func configureCell(name: String?, profileImage: UIImage?, index: Int) {
        self.profileImage = profileImage
        if let name = name {
            self.name = name
        }
        self.index = index
        if profileImage == nil {
            var color = UIColor()
            let colorCase = index%4
            switch colorCase {
            case 0:
                color = CustomizeColor.lessStrongBackgroundNino()
            case 1:
                color = CustomizeColor.borderColourNino()
            case 2:
                color = CustomizeColor.lightPink()
            case 3:
                color = CustomizeColor.strongPink()
            default:
                break
            }
            guard let thisimageView = profileImageView else {
                return
            }
            thisimageView.setNeedsLayout()
            thisimageView.layoutIfNeeded()
            thisimageView.setImageWithString(self.name, color: color, circular: true)
        }
    }

    override func layoutSubviews() {
    super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
