//
//  DeputyTableViewCell.swift
//  Que hacen los diputados
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit

class DeputyTableViewCell: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var party: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProfileImage(image: UIImage) {
        self.profile.image = image.cropImage(CGRectMake(0, 0, 150, 120))
        
        // Make round profil-y image
        self.profile.layer.cornerRadius =  self.profile.frame.size.width / 2;
        self.profile.clipsToBounds = true
        self.profile.layer.borderWidth = 4.0
        self.profile.layer.borderColor = UIColor(red: 0.71, green: 0.71, blue: 0.71, alpha: 1).CGColor
    }
}
