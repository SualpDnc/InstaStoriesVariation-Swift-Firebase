//
//  FeedCell.swift
//  InstaStories
//
//  Created by Sualp DANACI on 11.08.2024.
//

import UIKit

class FeedCell: UITableViewCell {
  
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
