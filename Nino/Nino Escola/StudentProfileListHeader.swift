//
//  TableSectionHeader.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/9/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var classroomButton: UIButton!
    var delegate: StudentProfileListHeaderDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func didSelectToChangeLabel(sender: UIButton) {
        self.delegate?.didTapPhaseButton(sender)
    }
}


protocol StudentProfileListHeaderDelegate {
    func didTapPhaseButton(sender: UIButton)
}

