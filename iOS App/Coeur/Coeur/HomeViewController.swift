//
//  HomeViewController.swift
//  Coeur
//
//  Created by Sally Moon on 2019-01-23.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func onNewUserPressed(_ sender: UIButton) {
        if self.view.backgroundColor == .green {
            
        }
        self.view.backgroundColor = (self.view.backgroundColor == .green) ? .red : .green
    }
}
