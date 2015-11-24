//
//  NewsTableViewCell.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 21.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    var newsId = 0
    var newsText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
