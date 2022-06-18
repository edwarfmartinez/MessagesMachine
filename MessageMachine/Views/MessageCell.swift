//
//  MessageCell.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  messageBubble.layer.cornerRadius = messageBubble.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
