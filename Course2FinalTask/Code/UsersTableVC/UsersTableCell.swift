//
//  UsersTableCell.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/10/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class UsersTableCell: UITableViewCell {

    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
