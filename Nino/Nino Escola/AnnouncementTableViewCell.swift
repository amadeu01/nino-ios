//
//  AnnouncementTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var announcementTitle: UILabel!
    @IBOutlet weak var draftLabel: UILabel!
    @IBOutlet weak var noTitleLabel: UILabel!
    var sent: Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        //draft Label color
        draftLabel.textColor = CustomizeColor.lessStrongBackgroundNino()
        // Initialization code
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = CustomizeColor.borderColourNino()
        self.addSubview(border)
        let borderConstraints = [FluentConstraint(border).top.equalTo(self).top.activate(), FluentConstraint(border).trailing.equalTo(self).trailing.activate(), FluentConstraint(border).height.equalTo(1).activate(), FluentConstraint(border).leading.plus(-90).equalTo(self).leading.activate()]
        
        
        self.addConstraints(borderConstraints)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /**
     Hides the draft symbol if the announcement is not a draft
     */
    func sentAnnouncement(sent:Bool){
        draftLabel.hidden = sent
        self.sent = sent
    }
    
    func withTitle(present:Bool){
        noTitleLabel.hidden = present// Shows a placeholder if there's no title
    }
    
}

