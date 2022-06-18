//
//  WelcomeViewController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//  

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    //unwind segue for logouts across the app
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var charIndex = 0.0
        titleLabel.text = ""
        let titletext = K.appName
        for letter in titletext
        {            
            Timer.scheduledTimer(withTimeInterval: 0.1*charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
       
    }
    

}
