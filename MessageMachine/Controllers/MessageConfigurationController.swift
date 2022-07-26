//
//  MessageConfigurationController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 10/06/22.
//

import UIKit
import Firebase
import SwipeCellKit

class MessageConfigurationController: NavigationBarController, NavigationBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        callFromMessageConfiguration = true
        tableView.dataSource = self
        tableView.delegate = self
        messagesMachineManager.messageConfigurationDelegate = self
        navigationBarDelegate = self
        
        //title = K.tabMessageConfigTitle
        formatter.dateFormat = K.dateFormat
        
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibNameMessage, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        messagesMachineManager.messageConfigurationRead()
        initSearchController(showSenderFilter: false)
        
        //accessibilityIdentifiers for UItest
        //categoryPicker.accessibilityIdentifier = "categoryPicker"

    }
    
    //MARK: Delete Message Configuration
    func deleteMessage(_ docId: String){
        print("MessageConfigurationController - deleteMessage")

        messagesConf.removeAll{ $0.docId == docId }
        self.messagesMachineManager.messageConfigurationDelete(docId: docId)
        self.messagesMachineManager.messageConfigurationRead()
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("MessageConfigurationController - prepare")

        guard segue.identifier != nil else {
            messagesMachineManager.stopAllTimers()
            return
        }
        let destinationVC = segue.destination as! CreateUpdateMessage
        if let indexPath = tableView.indexPathForSelectedRow  {
            destinationVC.messagesConfiguration = messagesConf[indexPath.row]
        }
    }
    
    //MARK: TableView functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("MessageConfigurationController - numberOfSections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("MessageConfigurationController - numberOfRowsInSection")
        if(searchController.isActive) {
            return filteredMessagesConf.count
        }
        return messagesConf.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("MessageConfigurationController - cellForRowAt")

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message: MessageConfiguration! = searchController.isActive ? filteredMessagesConf[indexPath.row] : messagesConf[indexPath.row]
        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
        let dateString = formatter.string(from: nsDate as Date)
        
        cell.delegate = self
        cell.category.text = K.FStore.MessageConfiguration.categories[message.category]
        cell.message.text = message.body
        cell.frequency.text = String(message.frequency)
        cell.receiver.text = message.sendTo.joined(separator: K.sendToSeparator)
        cell.date.text = dateString
        
        cell.senderView.isHidden=true
        cell.receiverView.isHidden=false
        cell.dateView.isHidden=false
        cell.messageView.isHidden=false
        cell.frequencyView.isHidden=false
        cell.categoryView.isHidden=false

        return cell
        
    }
    
    //MARK: Filter functions
    func didUpdateFilter(_ navigationBarController: NavigationBarController) {
        print("MessageConfigurationController - didUpdateFilter")
        tableView.reloadData()
    }
}

//MARK: Delegates

extension MessageConfigurationController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
       
        print("MessageConfigurationController - editActionsForRowAt")

        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteMessage(self.messagesConf[indexPath.row].docId)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: K.cellSwipeDeleteIcon)
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

extension MessageConfigurationController:MessageConfigurationDelegate{
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages: [MessageConfiguration]) {
        
        print("MessageConfigurationController - MessageConfigurationDelegate")
        DispatchQueue.main.async {
            
            self.messagesConf = messages
            self.tableView.reloadData()
            //Fix the scroll for messages
            let numRows = self.searchController.isActive ? self.filteredMessagesConf.count : self.messagesConf.count
            
            if numRows > 0 {
                print("Scroll to reach the end of tableview")
                let indexPath =  IndexPath(row: numRows-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}

extension MessageConfigurationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("MessageConfigurationController - didSelectRowAt")

        performSegue(withIdentifier: K.Segues.messageConfigurationDetail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
