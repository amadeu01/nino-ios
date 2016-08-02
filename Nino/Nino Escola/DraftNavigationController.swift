//
//  DraftNavigationController.swift
//  ninoEscola
//
//  Created by Amadeu Cavalcante on 07/12/2015.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class DraftNavigationController: UINavigationController {

    var newView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        //initNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    private func initNavBar() {
        newView = UILabel()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = CustomizeColor.clearBackgroundNino()
        //newView.text = "Novo Recado"
        newView.textAlignment = .Center
        self.navigationBar.addSubview(newView)
        
        let constraintsView = [FluentConstraint(newView).leading.equalTo(self.navigationBar).leading.activate(),
            FluentConstraint(newView).trailing.equalTo(self.navigationBar).trailing.activate(),
            FluentConstraint(newView).bottom.equalTo(self.navigationBar).bottom.activate(),
            FluentConstraint(newView).top.equalTo(self.navigationBar).top.activate()]
        
        self.navigationBar.addConstraints(constraintsView)
    }

}
