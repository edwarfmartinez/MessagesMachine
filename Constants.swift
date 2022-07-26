struct K {
    static let appName = "🎛\nMessages\nMachine"
    static let tabMessagesTitle = "Messages"
    static let tabMessageConfigTitle = "Message Configuration"
    static let tabChartTitle = "Charts"

    static let cellIdentifier = "ReusableCell"
    static let cellNibNameMessage = "MessageCell"
    static let cellSwipeDeleteLabel = "Delete"
    static let cellSwipeDeleteIcon = "delete-icon"
    static let registerSegue = "RegisterToChat"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    static let maxNumberOfReceivers = 10
    
    static let errorMsgSavingData = "There was an issue saving data: "
    static let errorMsgDeletingData = "There was an issue removing data: "
    static let errorMsgSignOut = "Error signing out: %@"
    static let errorMsgGetDocument = "Error getting documents: "
    static let errorMsgEmptyField = "Required"
    static let errorMsgInvalidEmail = "Invalid e-mail address"
    static let errorMsgMinNumberOfReceivers = "You should add at least one receiver"
    static let errorMsgMaxNumberOfReceivers = "You reached the maximum number of receivers"
    static let errorMsgDelegate = "This is a messagesDelegate error"

    static let errorMsgRepeatedReceiver = "The receiver is already included"
    static let errorMsgDocuments = "Error getting documents: "
    static let successMsgDeletingData = "Document successfully removed!"
    
    
    
    static let alphaNumericValues = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    static let docIdLength = 20
    static let textFieldLength = 20
    
    
    static let emailRegExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let emailFormat = "SELF MATCHES %@"
    static let sendToSeparator = ", "
    static let chartConventions = "Messages category"
    
    static let btnInboxLabel = "Inbox"
    static let btnSentLabel = "Sent"

    
    
    
    
    struct Segues {
        static let loginToChat = "LoginToChat"
        static let messageConfigurationDetail = "MessageConfigurationDetail"
        
    }
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        
        struct Messages {
            static let collectionName = "messages"
            
            static let senderField = "sender"
            static let receiverField = "receiver"
            static let bodyField = "body"
            static let dateField = "date"
            static let frequencyField = "frequency"
            static let categoryField = "category"
        }
        
        struct MessageConfiguration {
            static let collectionName = "messageConfiguration"
            static let categories: [Int: String] = [
                0: "All the company",
                1: "Sales team",
                2: "Management",
                3: "IT Team",
                4: "House keeping"
            ]
            
            static let docIdField = "docId"
            static let ownerField = "owner"
            static let categoryField = "category"
            static let frequencyField = "frequency"
            static let messageField = "message"
            static let sendToField = "sendTo"
            static let dateField = "date"
        }
    }
    
    struct searchButtons {
        static let sender = "Sender"
        static let date = "Date"
        static let message = "Messsage"
        static let receiver = "Receiver"
        static let category = "Category"
    }
    
    struct accessibilityIdentifiers{
        static let messagesTableView = "MessagesTableView"
        static let date = "Date"
        static let message = "Messsage"
        static let receiver = "Receiver"
        static let category = "Category"
    }
}
