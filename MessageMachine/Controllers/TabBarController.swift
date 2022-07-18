//
//  TabBarController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 6/06/22.
//

import UIKit
import Firebase

class TabBarController: UIViewController{

    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
       print("xxxxxxxxxx")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //navigationController?.setNavigationBarHidden(false, animated: false)
        
//        super.viewWillAppear(animated)
//                setText()
//                NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        
        
    }

//    @objc func setText() {
//
//            tabBar.items?[0].title = Localized("Tab name 1").uppercased()
//            tabBar.items?[1].title = Localized("Tab name 2").uppercased()
//            tabBar.items?[2].title = Localized("Tab name 3").uppercased()
//            tabBar.items?[3].title = Localized("Tab name 4").uppercased()
//        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
   
}
