//
//  UserScoreTableViewCell.swift
//  geoapp
//
//  Created by nguyen thanh vy on 25.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit

class UserScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
