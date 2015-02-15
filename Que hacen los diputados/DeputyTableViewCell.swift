//
//  DeputyTableViewCell.swift
//  Que hacen los diputados
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit

class DeputyTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
