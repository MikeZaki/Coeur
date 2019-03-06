//
//  AvatarCreationViewController.swift
//  Coeur
//
//  Created by Winnie Fong on 1/30/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class AvatarCreationViewController: UIViewController {
    
    @IBAction func onNewUserPressed(_ sender: UIButton) {
        if self.view.backgroundColor == .green {
            
        }
        self.view.backgroundColor = (self.view.backgroundColor == .green) ? .red : .green
    }
}
