struct K {
    static let appName = "🎛\nMessages\nMachine"
    static let appMessageConfigurationTitle = "🎛 Message Configuration"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibNameMessage = "MessageCell"
    static let cellNibNameMessageConfiguration = "MessageConfigurationCell"
    static let cellSwipeDeleteLabel = "Delete"
    static let cellSwipeDeleteIcon = "delete-icon"
    static let registerSegue = "RegisterToChat"
    
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    static let maxNumberOfReceivers = 10
    
    
    
    
    static let alertTitle = "⚠️"
    static let alertButtonLabel = "Ok"
    
    static let errorMsgSavingData = "There was an issue saving data: "
    static let errorMsgDeletingData = "There was an issue removing data: "
    static let errorMsgSignOut = "Error signing out: %@"
    static let errorMsgGetDocument = "Error getting documents: "
    static let errorMsgEmptyField = "Required"
    static let errorMsgInvalidEmail = "Invalid e-mail address"
    static let errorMsgMinNumberOfReceivers = "You should add at least one receiver"
    static let errorMsgMaxNumberOfReceivers = "You reached the maximum number of receivers"
    static let errorMsgRepeatedReceiver = "The receiver is already included"
    static let errorMsgDocuments = "Error getting documents: "
    
    static let successMsgDeletingData = "Document successfully removed!"
    
    
    
    static let alphaNumericValues = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    static let docIdLength = 20
    static let textFieldLength = 20
    
    
    static let emailRegExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let emailFormat = "SELF MATCHES %@"
    static let sendToSeparator = ", "
    
    
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
        }
        
        struct MessageConfiguration {
            static let collectionName = "messageConfiguration"
            static let categories: [Int: String] = [
                0: "Category1",
                1: "Category2",
                2: "Category3",
                3: "Category4",
                4: "Category5"
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
}
