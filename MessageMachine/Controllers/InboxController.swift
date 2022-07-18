//
//  ChatViewController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import UIKit
import Firebase

class InboxController: NavigationBarController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func inboxTouch(_ sender: UIButton) {
        //searchButtons = [K.searchButtons.sender, K.searchButtons.date, K.searchButtons.category]

        messagesMachineManager.messagesRead(fromInbox:true, fromCharts: false)
        initSearchController(showSenderFilter: true)
    }
    @IBAction func sentTouch(_ sender: UIButton) {
        //searchButtons = [K.searchButtons.receiver, K.searchButtons.date, K.searchButtons.category]
        //messagesMachineManager.flagInbox=false
        messagesMachineManager.messagesRead(fromInbox:false, fromCharts: false)
        initSearchController(showSenderFilter: true)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        messagesMachineManager.inboxDelegate = self
        messagesMachineManager.messageConfigurationDelegate = self
        navigationBarDelegate = self
        tableView.dataSource = self
        //title = K.tabMessagesTitle
        //tabMessages.title=""
        formatter.dateFormat = K.dateFormat
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibNameMessage, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    
        messagesMachineManager.messageConfigurationRead()
        messagesMachineManager.messagesRead(fromInbox: true, fromCharts: false)
        initSearchController(showSenderFilter: true)

    }
    
    
    
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
        
//        cell.senderView.isHidden = !messagesMachineManager.flagInbox
//        cell.receiverView.isHidden = messagesMachineManager.flagInbox
        
        cell.senderView.isHidden = false
        cell.receiverView.isHidden = true
        
        
        return cell
    }
    
    //MARK: Logout
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        messagesMachineManager.stopAllTimers()
    }
}

extension InboxController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchController.isActive) {
            return filteredMessages.count
        }
        return messagesMachineManager.messages.count
    }
}

// MARK: Delegates

extension InboxController : NavigationBarDelegate{
    func didUpdateFilter(_ navigationBarController: NavigationBarController) {
        tableView.reloadData()
    }
}

extension InboxController : MessageConfigurationDelegate{
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages: [MessageConfiguration]) {
        messagesConf = messages
        messagesMachineManager.setTimers(messages: messagesConf)

    }
}

extension InboxController: MessagesDelegate{
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
