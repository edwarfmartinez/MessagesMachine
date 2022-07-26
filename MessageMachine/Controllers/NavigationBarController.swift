//
//  NavigationBarController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 30/06/22.
//

import UIKit


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
    var messagesMachineManager = MessagesMachineManager()
    var searchButtons: [String] = []
    let formatter = DateFormatter()
    var callFromMessageConfiguration = false
    
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
        searchController.searchBar.scopeButtonTitles = searchButtons
        
        //SearchBar colors (Buttons, texts)
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchTextField.backgroundColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange ], for: UIControl.State.normal)
        
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
        //Check if search bar comes from Inbox/Sent or MessageConfig
        //guard searchButtons.contains(K.searchButtons.sender) && callFromMessageConfiguration
        guard callFromMessageConfiguration
        else {
            //Filter for messages (Inbox/Sent. Tab N°1)
            filteredMessages = messages.filter
            {
                message in
                guard (searchController.searchBar.text != "") else { return true }
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
                    
                    return
                        K.FStore.MessageConfiguration.categories[message.category]!.lowercased().contains(searchText.lowercased())
                    
                    //let categoryText = K.FStore.MessageConfiguration.categories[message.category]!
                    //return categoryText.contains(searchText.lowercased())
                default:
                    return false
                }
            }
            self.navigationBarDelegate?.didUpdateFilter(self)
            return
        }
        
        //Filter for messages configuration (Tab N°2)
        filteredMessagesConf = messagesConf.filter
        {
            message in
            guard(searchController.searchBar.text != "") else { return true }
            
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
        self.navigationBarDelegate?.didUpdateFilter(self)
        
    }
}
