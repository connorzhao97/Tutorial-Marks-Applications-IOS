//
//  StudentListTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit

class StudentListTableViewCell: UITableViewCell {
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var studentAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
