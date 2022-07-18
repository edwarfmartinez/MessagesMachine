//
//  MessageConfigurationCell.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 13/06/22.
//

import UIKit
import SwipeCellKit

class MessageCell: SwipeTableViewCell {

//    @IBOutlet weak var senderStack: UIStackView!
//    @IBOutlet weak var receiverStack: UIStackView!
//    @IBOutlet weak var dateStack: UIStackView!
//    @IBOutlet weak var messageStack: UIStackView!
//    @IBOutlet weak var categoryStack: UIStackView!
//    @IBOutlet weak var frequencyStack: UIStackView!
    
    @IBOutlet weak var senderView: UIStackView!
    @IBOutlet weak var receiverView: UIStackView!
    @IBOutlet weak var dateView: UIStackView!
    @IBOutlet weak var messageView: UIStackView!
    @IBOutlet weak var categoryView: UIStackView!
    @IBOutlet weak var frequencyView: UIStackView!
    
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var receiver: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var frequency: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
