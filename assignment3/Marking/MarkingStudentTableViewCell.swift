//
//  MarkingStudentTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class MarkingStudentTableViewCell: UITableViewCell {
    @IBOutlet var attendanceView: UIView!
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var attendanceCheck: UISwitch!


    var grade: Double! = 0.0
    var selectedWeek: String!
    var selectedScheme: String!
    var studentIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func attendanceValueChanged(_ sender: Any) {
        var grade = 0.0
        if attendanceCheck.isOn {
            grade = 100.0
        }

        if let studentIndex = studentIndex {
            studentCollection.document(students[studentIndex].id!).updateData([
                "grades.\(selectedWeek!)": grade
                ]) { err in
                if let err = err {
                    print("Error updating ducoment:\(err)")
                } else {
                    print("Document successfully updated")
                    students[studentIndex].grades[self.selectedWeek] = grade
                }
            }
        }
    }



}
