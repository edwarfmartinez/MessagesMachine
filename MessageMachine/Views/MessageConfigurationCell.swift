//
//  MessageConfigurationCell.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 13/06/22.
//

import UIKit
import SwipeCellKit

class MessageConfigurationCell: SwipeTableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblSendTo: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
