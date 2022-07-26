//
//  ChatViewController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import UIKit
import Firebase

class MessagesViewController: NavigationBarController, NavigationBarDelegate {
    
    func didUpdateFilter(_ navigationBarController: NavigationBarController) {
        print("MessageConfigurationController - didUpdateFilter")
        tableView.reloadData()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var showSenderFilter = true
    
    @IBAction func inboxTouch(_ sender: UIButton) {
        showSenderFilter = true
        messagesMachineManager.messagesRead(fromInbox:true, fromCharts: false)
        initSearchController(showSenderFilter: showSenderFilter)

    }
    
    @IBAction func sentTouch(_ sender: UIButton) {
        showSenderFilter = false
        messagesMachineManager.messagesRead(fromInbox:false, fromCharts: false)
        initSearchController(showSenderFilter: showSenderFilter)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        messagesMachineManager.inboxDelegate = self
        messagesMachineManager.messageConfigurationDelegate = self
        navigationBarDelegate = self
        tableView.dataSource = self
        formatter.dateFormat = K.dateFormat
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibNameMessage, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    
        messagesMachineManager.messageConfigurationRead()
        messagesMachineManager.messagesRead(fromInbox: true, fromCharts: false)
        callFromMessageConfiguration = false
        initSearchController(showSenderFilter: true)
        
        self.view.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "MessagesTableView"


    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        let message: Message! = searchController.isActive ? filteredMessages[indexPath.row] : messages[indexPath.row]
        
        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
        let dateString = formatter.string(from: nsDate as Date)
        
        cell.sender.text = message.sender
        cell.receiver.text = message.receiver
        cell.date.text = dateString
        cell.message.text = message.body
        cell.category.text = K.FStore.MessageConfiguration.categories[message.category]
        
        cell.senderView.isHidden = !showSenderFilter
        cell.receiverView.isHidden = showSenderFilter
        
        return cell
    }
    
    //MARK: Logout
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        messagesMachineManager.stopAllTimers()
    }
    
    
    
    
}




extension MessagesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchController.isActive) {
            return filteredMessages.count
        }
        return messagesMachineManager.messages.count
    }
}

// MARK: Delegates



extension MessagesViewController : MessageConfigurationDelegate{
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages: [MessageConfiguration]) {
        messagesConf = messages
        messagesMachineManager.setTimers(messages: messagesConf)

    }
}

extension MessagesViewController: MessagesDelegate{
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages: [Message]) {
        self.messages = messages
        print("MessagesDelegate - num of messages: \(messagesMachineManager.messages.count)")

        DispatchQueue.main.async {
            self.tableView.reloadData()
            //Fix the scroll for messages
            let numRows = self.searchController.isActive ? self.filteredMessages.count : self.messages.count
            
            if numRows > 0 {
                print("Going to scroll tableview to row \(numRows)")
                let indexPath =  IndexPath(row: numRows-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print("This is a messagesDelegate error: \(error)")
    }
}
