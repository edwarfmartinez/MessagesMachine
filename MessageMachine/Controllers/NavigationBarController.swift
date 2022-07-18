//
//  NavigationBarController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 30/06/22.
//

import UIKit


//protocol NavigationBarDelegate {
//    func didUpdateFilter(_ navigationBarController: NavigationBarController, message:[Message])
//}

protocol NavigationBarDelegate {
    func didUpdateFilter(_ navigationBarController: NavigationBarController)
}

class NavigationBarController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    var navigationBarDelegate: NavigationBarDelegate?
    
    let searchController = UISearchController()
    var filteredMessages : [Message] = []
    var messages : [Message] = []
    var filteredMessagesConf : [MessageConfiguration] = []
    var messagesConf : [MessageConfiguration] = []
    
    var searchButtons: [String] = []
    
    
    var messagesMachineManager = MessagesMachineManager()
    let formatter = DateFormatter()
    
    
    func initSearchController(showSenderFilter: Bool)
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        //Change 1st search bar button. For inbox msgs add "sender" button, for sent messages add "receiver" button
        searchButtons = [showSenderFilter ? K.searchButtons.sender : K.searchButtons.receiver, K.searchButtons.date, K.searchButtons.category]

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        //searchController.searchBar.scopeButtonTitles = [K.searchButtons.sender, K.searchButtons.date, K.searchButtons.message]
        searchController.searchBar.scopeButtonTitles = searchButtons

        searchController.searchBar.delegate = self
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
        
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String)
    {
        print("filterForSearchTextAndScopeButton - ")
        
        //Check if search bar comes from Inbox/Sent or MessageConfig
        if searchButtons.contains(K.searchButtons.receiver) {
            //Filter for messages configuration (Tab N°2)
            filteredMessagesConf = messagesConf.filter
            {
                message in
                if(searchController.searchBar.text != "")
                {
                    switch scopeButton {
                    case K.searchButtons.receiver:
                        let stringRepresentation = message.sendTo.joined(separator: " ")
                        return stringRepresentation.contains(searchText.lowercased())
                    case K.searchButtons.date:
                        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
                        let dateString = formatter.string(from: nsDate as Date)
                        return dateString.contains(searchText.lowercased())
                    case K.searchButtons.category:
                        return
                            K.FStore.MessageConfiguration.categories[message.category]!.lowercased().contains(searchText.lowercased())
                    default:
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
        }
        else {
            //Filter for messages (Inbox/Sent. Tab N°1)
            filteredMessages = messagesMachineManager.messages.filter
            {
                message in
                if(searchController.searchBar.text != "")
                {
                    switch scopeButton {
                    case K.searchButtons.sender:
                        return message.sender.lowercased().contains(searchText.lowercased())
                    case K.searchButtons.receiver:
                        return message.receiver.lowercased().contains(searchText.lowercased())
                    case K.searchButtons.date:
                        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(message.date))
                        let dateString = formatter.string(from: nsDate as Date)
                        return dateString.contains(searchText.lowercased())
                    case K.searchButtons.message:
                        return message.body.lowercased().contains(searchText.lowercased())
                    case K.searchButtons.category:
                        let categoryText = K.FStore.MessageConfiguration.categories[message.category]!
                        return categoryText.contains(searchText.lowercased())
                    default:
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
        }
        
        self.navigationBarDelegate?.didUpdateFilter(self)
    }
    
    
}
