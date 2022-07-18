//
//  PieChart.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 15/07/22.
//

import Foundation

struct PieChart{
    var numberOfMessages: Int
    var category: String
    
    init(numberOfMessages: Int=0, category: String=""){
        self.numberOfMessages = numberOfMessages
        self.category = category
    }
}
