//
//  ChatViewController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            super.navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print(K.errorMsgSignOut, signOutError)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var messages : [Message] = [] // Save all messages in this var
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //tableView.delegate=self
        title = K.appName
        formatter.dateFormat = K.dateFormat
        
        
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibNameMessage, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    
    func loadMessages(){
        
        // Query to Firebase collection
        db.collection(K.FStore.Messages.collectionName).order(by: K.FStore.Messages.dateField).addSnapshotListener() { (querySnapshot, err) in
            self.messages = [] // Save all messages in this variable
            if let err = err {
                print("\(K.errorMsgDocuments)\(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if (data[K.FStore.Messages.receiverField] as! String) == Auth.auth().currentUser?.email { // Add messages only if receiver is the logged user
                            
                            if let messageSender = data[K.FStore.Messages.senderField] as? String,
                               let messageBody = data[K.FStore.Messages.bodyField] as? String,
                               let messageReceiver = data[K.FStore.Messages.receiverField] as? String,
                               let messageDate = data[K.FStore.Messages.dateField] as? Double
                            
                            {
                                let newMessage = Message(sender: messageSender, date: messageDate, body: messageBody, receiver: messageReceiver)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    //Fix the scroll for messages
                                    let indexPath =  IndexPath(row: self.messages.count-1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageSender = Auth.auth().currentUser?.email{ //Add document to collection when button pressed
            db.collection(K.FStore.Messages.collectionName)
                .addDocument(data: [
                    K.FStore.Messages.senderField: messageSender,
                    K.FStore.Messages.receiverField: sender.currentTitle!,
                    K.FStore.Messages.bodyField:"Test message",
                    K.FStore.Messages.dateField:Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("\(K.errorMsgSavingData)\(e.localizedDescription)")
                    }
                    //else {
                    //   print("Saved succesfully")
//                                                DispatchQueue.main.async {
//                                                    self.messageTextfield.text=""
//                                                }
                 //   }
                }
        }
    }
    
    
}



extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        
        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
        let dateString = formatter.string(from: nsDate as Date)
        
        cell.body.text = message.body
        cell.sender.text = message.sender
        
        cell.date.text = dateString
        return cell
        
    }
}

//extension ChatViewController: UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//
//}

