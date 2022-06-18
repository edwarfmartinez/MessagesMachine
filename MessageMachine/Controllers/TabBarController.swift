//
//  TabBarController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 6/06/22.
//

import UIKit
import Firebase

class TabBarController: UIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
   
}
