//
//  MessageMachineManager.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 21/06/22.
//

import Foundation
import Firebase

//MARK: Protocols

protocol MessagesDelegate {
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages:[Message])
    
    func didFailWithError(error: Error)
}

protocol MessageConfigurationDelegate {
    func didUpdateMessages(_ messagesMachineManager: MessagesMachineManager, messages:[MessageConfiguration])
}

protocol DataChartDelegate {
    func didUpdateChart(_ messagesMachineManager: MessagesMachineManager, messages:[Message])
}



class MessagesMachineManager {
    
    //MARK: Variables
    
    var inboxDelegate: MessagesDelegate?
    var messageConfigurationDelegate: MessageConfigurationDelegate?
    var dataChartDelegate: DataChartDelegate?
    
    let db = Firestore.firestore()
    var firestoreListener = ListenerRegistration?.init(nilLiteral: ())
    var messages: [Message] = []
    var messageConfiguration : [MessageConfiguration] = []
    
    let formatter = DateFormatter()
    let searchController = UISearchController()
   
    
    //MARK: Inbox/Sent
    
    
    func messageCreate(message: MessageConfiguration){
        //Create a new message for each receiver included in the "send to" variable
        for receiver in message.sendTo {
            print("Creating a document for: \(receiver): \(message.body)")
            db.collection(K.FStore.Messages.collectionName)
                .addDocument(data: [
                    K.FStore.Messages.senderField: Auth.auth().currentUser?.email,//messageSender,
                    K.FStore.Messages.receiverField: receiver,
                    K.FStore.Messages.bodyField: message.body,
                    K.FStore.Messages.categoryField: message.category,
                    K.FStore.Messages.dateField: Date().timeIntervalSince1970
                    
                ]) { (error) in
                    guard let e = error else {
                        print("Message saved succesfully")
                        return }
                    
            print("\(K.errorMsgSavingData)\(e.localizedDescription)")

                    
                }
        }
    }
    
    func messagesRead(fromInbox: Bool, fromCharts: Bool){
        
        firestoreListener?.remove()
        firestoreListener = db.collection(K.FStore.Messages.collectionName).whereField(fromInbox ? K.FStore.Messages.receiverField : K.FStore.Messages.senderField, isEqualTo: Auth.auth().currentUser?.email).order(by: K.FStore.Messages.dateField).addSnapshotListener() { (querySnapshot, err) in
            self.messages = [] // Save all messages in this variable
            
            if let err = err {
                print("\(K.errorMsgDocuments)\(err)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                for doc in snapshotDocuments{
                    let data = doc.data()
                    guard let messageSender = data[K.FStore.Messages.senderField] as? String,
                          let messageBody = data[K.FStore.Messages.bodyField] as? String,
                          let messageReceiver = data[K.FStore.Messages.receiverField] as? String,
                          let messageDate = data[K.FStore.Messages.dateField] as? Double,
                          let messageCategory = data[K.FStore.Messages.categoryField] as? Int
                    else { return }
                    
                    let newMessage = Message(sender: messageSender, date: messageDate, body: messageBody, receiver: messageReceiver, category: messageCategory)
                    self.messages.append(newMessage)
                }
            }
            print("messagesRead - fromCharts: \(fromCharts)")
            
            //Sent data to Charts Or Inbox/Sent depending on the origin of the call
            guard fromCharts else {
                self.inboxDelegate?.didUpdateMessages(self, messages: self.messages)
                return
            }
            self.firestoreListener?.remove()
            self.dataChartDelegate?.didUpdateChart(self, messages: self.messages)
            
        }
    }
    
    
    //MARK: Message Configuration CRUD
    
    func messageConfigCreateUpdate(message: MessageConfiguration){
        
        db.collection(K.FStore.MessageConfiguration.collectionName).document(message.docId == "" ? generateMessageConfigId : message.docId).setData([
            K.FStore.MessageConfiguration.ownerField: Auth.auth().currentUser?.email as Any,
            K.FStore.MessageConfiguration.categoryField: message.category,
            K.FStore.MessageConfiguration.frequencyField: Int(message.frequency),
            K.FStore.MessageConfiguration.messageField: message.body,
            K.FStore.MessageConfiguration.dateField: Date().timeIntervalSince1970,
            K.FStore.MessageConfiguration.sendToField: message.sendTo
        ])
        { (error) in
            if let e = error{
                print("\(K.errorMsgSavingData)\(e.localizedDescription)")
            } else {
                print("messageConfigCreateUpdate succesfully")
                self.setTimers(messages: self.messageConfiguration)
            }
        }
    }
    
    func messageConfigurationRead() {
        db.collection(K.FStore.MessageConfiguration.collectionName).whereField(K.FStore.MessageConfiguration.ownerField, isEqualTo: Auth.auth().currentUser?.email as Any).order(by: K.FStore.Messages.dateField).addSnapshotListener() { (querySnapshot, err) in
            self.messageConfiguration = [] // Save all messages in this variable
            if let err = err {
                print("\(K.errorMsgGetDocument)\(err)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                for doc in snapshotDocuments{
                    let data = doc.data()
                    guard (data[K.FStore.MessageConfiguration.ownerField] as! String) == Auth.auth().currentUser?.email else { return } // Show owner's messages only
                    
                    guard let messageConfCategory = data[K.FStore.MessageConfiguration.categoryField] as? Int,
                          let messageConfFrequency = data[K.FStore.MessageConfiguration.frequencyField] as? Int,
                          let messageConfMessage = data[K.FStore.MessageConfiguration.messageField] as? String,
                          let messageConfSendTo = data[K.FStore.MessageConfiguration.sendToField] as? [String],
                          let messageConfDate = data[K.FStore.MessageConfiguration.dateField] as? Double
                    else { return }
                    let newMessageConfiguration = MessageConfiguration(docId: doc.documentID, category: messageConfCategory, frequency: messageConfFrequency, message: messageConfMessage, sendTo: messageConfSendTo, date: messageConfDate)
                    self.messageConfiguration.append(newMessageConfiguration)
                }
            }
            print("Finish read all Messages Configuration")
            self.messageConfigurationDelegate?.didUpdateMessages(self, messages: self.messageConfiguration)
        }
    }
    
    func messageConfigDelete(docId: String){
        db.collection(K.FStore.MessageConfiguration.collectionName).document(docId).delete() { err in
            guard let err = err else {
                self.stopSpecificTimer(timerId: docId)
                print(K.successMsgDeletingData)
                return
            }
            print("\(K.errorMsgDeletingData)\(err)")
        }
    }
    
    // Creates new id for new message configuration
    var generateMessageConfigId: String {
        get {
            return String((0..<K.docIdLength).map{_ in K.alphaNumericValues.randomElement()!})
        }
    }
    
    
    //MARK: Timers setting
    
    func setTimers(messages: [MessageConfiguration]){
        
        for message in messages{
            
            if let timerExists = Timers.singletonTimers.timersDictionary[message.docId]{
                stopSpecificTimer(timerId: message.docId)
            }
            
            //Uses singleton dictionary to store timers so they can be deleted/updated/added over all the app
            Timers.singletonTimers.timersDictionary[message.docId] = Timer.scheduledTimer(timeInterval: Double(message.frequency), target: self, selector:#selector(self.startSendingMessages(sender:)), userInfo: message, repeats:true)
        }
        print("setTimers. Timers: \(Timers.singletonTimers.timersDictionary.keys)")
    }
    
    func stopSpecificTimer(timerId: String){
        Timers.singletonTimers.timersDictionary[timerId]?.invalidate()
        Timers.singletonTimers.timersDictionary[timerId] = nil
    }
    
    func stopAllTimers(){      
        Timers.singletonTimers.timersDictionary.keys.forEach { Timers.singletonTimers.timersDictionary[$0]?.invalidate()
        }
    }
    
    @objc func startSendingMessages(sender: Timer) {
        print("Timer: startSendingMessages")
        self.messageCreate(message: (sender.userInfo)! as! MessageConfiguration)
        
    }
    
}

