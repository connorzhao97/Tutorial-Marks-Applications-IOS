//
//  StudentDetailTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 5/5/21.
//

import UIKit

class StudentDetailTableViewCell: UITableViewCell {
    @IBOutlet var detailWeekLabel: UILabel!
    @IBOutlet var detailGradeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
