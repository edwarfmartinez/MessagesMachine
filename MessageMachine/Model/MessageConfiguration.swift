//
//  MessageConfiguration.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 7/06/22.
//

import Foundation

struct MessageConfiguration {
    var docId: String
    var category: Int
    var frequency: Int
    var message: String
    var sendTo: [String]
    let date: Double
    
    init(docId: String="", category: Int=0, frequency: Int=0, message: String="", sendTo: [String]=[], date: Double=0.0) {
        self.docId = docId
        self.category = category
        self.frequency = frequency
        self.message = message
        self.sendTo = sendTo
        self.date = date
    }
}
