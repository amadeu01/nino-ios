//
//  StudentProfileTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileTableViewCell: UITableViewCell {
    
    /**
     * Baby's picture in the cell
     */
    @IBOutlet weak var profileImageView: UIImageView!
    /**
     * Baby's name label
     */
    @IBOutlet weak var studentNameLabel: UILabel!
    /**
     * Baby's responsible name
     */
    @IBOutlet weak var guardianFirstNamesLabel: UILabel!
    
    
    internal var studentName: String? {
        didSet {
            self.studentNameLabel.text = studentName
        }
    }
    
    var studentID: String? {
        didSet {
            if let studentID = self.studentID {
                StudentBO.getStudentForID(studentID, completionHandler: { (student) in
                    do {
                        let student = try student()
                        self.studentName = student.name
//                        self.guardianFirstNames = student.
                        self.guardianFirstNames = student.guardians
                    } catch {
                        //TODO: handle error
                    }
                })
            }
        }
    }
    
    //internal var baby: Baby!
    
    // Sets the text according to the sponsors' names.
    internal var guardianFirstNames: [String]? {
        didSet {
            guard let guardianFirstNames = guardianFirstNames where guardianFirstNames.count > 0 else {
                // No parents.
                self.guardianFirstNamesLabel.text = "Responsável: ?"
                return
            }
            var text: String = ""
            if guardianFirstNames.count == 0 {
                text = "Responsável: \(guardianFirstNames[0])"
            } else {
                text = "Responsáveis: \(guardianFirstNames[0])"
                var i = 1
                while i < guardianFirstNames.count {
                    if i == (guardianFirstNames.count - 1) { //Last one
                        text.appendContentsOf(" e \(guardianFirstNames[i])")
                    } else {
                        text.appendContentsOf(", \(guardianFirstNames[i])")
                    }
                    i += 1
                }
                //Exits once adds every name
                guardianFirstNamesLabel.text = text
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.studentNameLabel.textColor = CustomizeColor.fontColourNino()
        self.studentNameLabel.font = NinoFont.fontForCellMainText()
        self.studentNameLabel.textColor = CustomizeColor.fontColourNino()
        self.guardianFirstNamesLabel.textColor = CustomizeColor.fontColourNino()
        self.guardianFirstNamesLabel.font = NinoFont.fontForCellSecondText()
        
        //border between cells
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = CustomizeColor.borderColourNino()
        self.addSubview(border)
        let borderConstraints = [FluentConstraint(border).bottom.equalTo(self).bottom.activate(), FluentConstraint(border).trailing.equalTo(self).trailing.activate(), FluentConstraint(border).height.equalTo(1).activate(), FluentConstraint(border).leading.plus(-90).equalTo(self).leading.activate()]
        self.addConstraints(borderConstraints)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.contentMode = .ScaleAspectFit
        self.profileImageView.layer.borderColor = CustomizeColor.whiteColor().CGColor
        self.profileImageView.layer.borderWidth = 2.0
        
    }
}
