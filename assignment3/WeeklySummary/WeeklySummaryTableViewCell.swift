//
//  WeeklySummaryTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 3/5/21.
//

import UIKit

class WeeklySummaryTableViewCell: UITableViewCell {

    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var studentGradeLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
