////
////  ChatViewController.swift
////  MessageMachine
////
////  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
////
//
//import UIKit
//import Firebase
//
////class SentController: UIViewController {
//class SentController: NavigationBarController, NavigationBarDelegate {
//    func didUpdateFilter(_ navigationBarController: NavigationBarController) {
//        tableView.reloadData()
//
//    }
//
//
//
////    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
////
////        do {
////            try Auth.auth().signOut()
////            super.navigationController?.popToRootViewController(animated: true)
////
////        } catch let signOutError as NSError {
////            print(K.errorMsgSignOut, signOutError)
////        }
////    }
//
//
//    @IBOutlet weak var tableView: UITableView!
//
//    let db = Firestore.firestore()
////    var messages : [Message] = [] // Save all messages in this var
////    let formatter = DateFormatter()
////    let searchController = UISearchController()
////    var filteredMessages : [Message] = []
////
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        messagesMachineManager.inboxDelegate = self
//
//        tableView.dataSource = self
//        navigationBarDelegate = self
//
//        //tableView.delegate=self
//        title = K.appName
//        formatter.dateFormat = K.dateFormat
//
//
//        navigationItem.hidesBackButton = true
//        tableView.register(UINib(nibName: K.cellNibNameMessage, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
//
//        //loadMessages()
//        //messagesMachineManager.loadMessages(fromInbox: false)
//
//
//        searchButtons = [K.searchButtons.receiver, K.searchButtons.date, K.searchButtons.message]
//        initSearchController()
//    }
//
//
////    func loadMessages()
////    {
////        // Query to Firebase collection
////        db.collection(K.FStore.Messages.collectionName).whereField(K.FStore.Messages.senderField, isEqualTo: Auth.auth().currentUser?.email as Any).order(by: K.FStore.Messages.dateField).addSnapshotListener() { (querySnapshot, err) in
////            self.messages = [] // Save all messages in this variable
////            if let err = err {
////                print("\(K.errorMsgDocuments)\(err)")
////            } else {
////                if let snapshotDocuments = querySnapshot?.documents{
////                    for doc in snapshotDocuments{
////                        let data = doc.data()
////
////                        if let messageSender = data[K.FStore.Messages.senderField] as? String,
////                           let messageBody = data[K.FStore.Messages.bodyField] as? String,
////                           let messageReceiver = data[K.FStore.Messages.receiverField] as? String,
////                           let messageDate = data[K.FStore.Messages.dateField] as? Double,
////                           let messageCategory = data[K.FStore.Messages.categoryField] as? Int
////
////                        {
////                            let newMessage = Message(sender: messageSender, date: messageDate, body: messageBody, receiver: messageReceiver, category: messageCategory)
////
////                            self.messages.append(newMessage)
////
////                            DispatchQueue.main.async {
////                                self.tableView.reloadData()
////                                //Fix the scroll for messages
////                                let numRows = self.searchController.isActive ? self.filteredMessages.count : self.messages.count
////
////                                if numRows > 0 {
////                                    let indexPath =  IndexPath(row: numRows-1, section: 0)
////                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
////                                }
////                            }
////                        }
////                    }
////                }
////            }
////        }
////    }
//}
//
//
//
//
//extension SentController: UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(searchController.isActive) {
//            return filteredMessages.count
//        }
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //let message = messages[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
//
//        let message: Message! = searchController.isActive ? filteredMessages[indexPath.row] : messages[indexPath.row]
//
//
//        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
//        let dateString = formatter.string(from: nsDate as Date)
//
//        cell.message.text = message.body
//        cell.receiver.text = message.receiver
//        cell.date.text = dateString
//        cell.category.text = K.FStore.MessageConfiguration.categories[message.category]
//
//        cell.frequency.isHidden = true
//        cell.frequencyTitle.isHidden = true
//        cell.sender.isHidden = true
//        cell.senderTitle.isHidden = true
//
//
//        return cell
//
//    }
//}
//
//
//
//// MARK: InboxDelegate
//
//extension SentController:MessagesDelegate{
//    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager) {
//        self.messages = messages
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//            //Fix the scroll for messages
//            let numRows = self.searchController.isActive ? self.filteredMessages.count : messagesMachineManager.messages.count
//
//            //print("numRows--------------------->\(numRows)")
//            if numRows > 0 {
//                var indexPath =  IndexPath(row: numRows-1, section: 0)
//                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//            }
//        }
//    }
//    func didFailWithError(error: Error) {
//
//        print(error)
//    }
//}
//
//
//
//// MARK: UISearchBarDelegate
//
////extension SentController: UISearchResultsUpdating, UISearchBarDelegate {
////
////    func initSearchController()
////    {
////        searchController.loadViewIfNeeded()
////        searchController.searchResultsUpdater = self
////        searchController.obscuresBackgroundDuringPresentation = false
////        searchController.searchBar.enablesReturnKeyAutomatically = false
////        searchController.searchBar.returnKeyType = UIReturnKeyType.done
////        definesPresentationContext = true
////
////        navigationItem.searchController = searchController
////        navigationItem.hidesSearchBarWhenScrolling = false
////        searchController.searchBar.scopeButtonTitles = [K.searchButtons.receiver, K.searchButtons.date, K.searchButtons.category]
////        searchController.searchBar.delegate = self
////    }
////
////
////    func updateSearchResults(for searchController: UISearchController) {
////        let searchBar = searchController.searchBar
////        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
////        let searchText = searchBar.text!
////        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
////
////    }
////
////    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String)
////    {
////        filteredMessages = messages.filter
////        {
////            message in
////            if(searchController.searchBar.text != "")
////            {
////                switch scopeButton {
////                case K.searchButtons.receiver:
////                    return message.receiver.lowercased().contains(searchText.lowercased())
////                case K.searchButtons.date:
////                    let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
////                    let dateString = formatter.string(from: nsDate as Date)
////                    return dateString.contains(searchText.lowercased())
////                case K.searchButtons.category:
////                    return  K.FStore.MessageConfiguration.categories[message.category]!.lowercased().contains(searchText.lowercased())
////                default:
////                    return false
////                }
////            }
////            else
////            {
////                return true
////            }
////        }
////        tableView.reloadData()
////    }
////
////
////}
