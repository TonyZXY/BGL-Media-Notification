//
//  FlashSearchTableViewCell.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 12/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class FlashSearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
}
