//
//  ChoiceSportsTableViewCell.swift
//  App_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class ChoiceSportsTableViewCell: UITableViewCell {

    @IBOutlet weak var mSportLabel: UILabel!
    @IBOutlet weak var mSportIcon: UIImageView!
    @IBOutlet weak var mSelectedImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
