//
//  MessageConfigurationController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 10/06/22.
//

import UIKit
import Firebase
import SwipeCellKit

class MessageConfigurationController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //unwind segue for logouts across the app
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){}
    
    let db = Firestore.firestore()
    var messageConfiguration : [MessageConfiguration] = []
    let formatter = DateFormatter()
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = K.appMessageConfigurationTitle
        
        
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibNameMessageConfiguration, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        
        // Query to Firebase collection
        db.collection(K.FStore.MessageConfiguration.collectionName).order(by: K.FStore.Messages.dateField).addSnapshotListener() { (querySnapshot, err) in
            self.messageConfiguration = [] // Save all messages in this variable
            if let err = err {
                print("\(K.errorMsgGetDocument)\(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if (data[K.FStore.MessageConfiguration.ownerField] as! String) == Auth.auth().currentUser?.email { // Show owner's messages only
                            
                            if let messageConfCategory = data[K.FStore.MessageConfiguration.categoryField] as? Int,
                               //let messageConfDocId = data[K.FStore.MessageConfiguration.docIdField] as? String?,
                               let messageConfFrequency = data[K.FStore.MessageConfiguration.frequencyField] as? Int,
                               let messageConfMessage = data[K.FStore.MessageConfiguration.messageField] as? String,
                               let messageConfSendTo = data[K.FStore.MessageConfiguration.sendToField] as? [String],
                               let messageConfDate = data[K.FStore.MessageConfiguration.dateField] as? Double
                            {
                                let newMessageConfiguration = MessageConfiguration(docId: doc.documentID, category: messageConfCategory, frequency: messageConfFrequency, message: messageConfMessage, sendTo: messageConfSendTo, date: messageConfDate)
                                self.messageConfiguration.append(newMessageConfiguration)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    //Fix the scroll for messages
                                    let indexPath =  IndexPath(row: self.messageConfiguration.count-1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func deleteMessage(_ docId: String){
        messageConfiguration.removeAll{ $0.docId == docId }
        db.collection(K.FStore.MessageConfiguration.collectionName).document(docId).delete() { err in
            if let err = err {
                print("\(K.errorMsgDeletingData)\(err)")
            } else {
                print(K.successMsgDeletingData)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CreateUpdateMessage
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.messageConfiguration = messageConfiguration[indexPath.row]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageConfiguration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messageConfiguration[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageConfigurationCell
        cell.delegate = self
        cell.lblCategory.text = K.FStore.MessageConfiguration.categories[message.category]
        cell.lblMessage.text = message.message
        cell.lblFrequency.text = String(message.frequency)
        cell.lblSendTo.text = message.sendTo.joined(separator: K.sendToSeparator)
        return cell
        
    }
}



//MARK: UITableViewDelegate

extension MessageConfigurationController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: K.Segues.messageConfigurationDetail, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: SwipeTableViewCellDelegate

extension MessageConfigurationController: SwipeTableViewCellDelegate{
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteMessage(self.messageConfiguration[indexPath.row].docId)
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
