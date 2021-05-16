//
//  MarkingStudentTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class MarkingStudentTableViewCell: UITableViewCell {
    // Views
    @IBOutlet var attendanceView: UIView!
    @IBOutlet var gradeHDView: UIView!
    @IBOutlet var gradeAView: UIView!
    @IBOutlet var scoreOutOfView: UIView!
    @IBOutlet var multipleCheckpointView: UIView!

    // Labels
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var studentAvatar: UIImageView!

    // Marking Scheme
    @IBOutlet var attendanceCheck: UISwitch!
    @IBOutlet var segmentHDGradeLevel: UISegmentedControl!
    @IBOutlet var segmentAGradeLevel: UISegmentedControl!

    // Score out of 100
    @IBOutlet var scoreTF: UITextField!
    @IBOutlet var btnScoreOutOfLabel: UIButton!
    @IBOutlet var displayScoreOutOf: UILabel!
    // Multiple checkbox
    @IBOutlet var checkpoint2Label: UILabel!
    @IBOutlet var checkpoint1Switch: UISwitch!
    @IBOutlet var checkpoint2Switch: UISwitch!

    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var grade: Double! = 0.0
    var selectedWeek: String!
    var selectedScheme: String!
    var studentIndex: Int?
    var ScoreOutOfUpdateState = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Attendance changed function
    @IBAction func attendanceValueChanged(_ sender: Any) {
        var grade = 0.0
        if attendanceCheck.isOn {
            grade = 100.0
        }
        self.updateGrade(grade, markingScheme: "Attendance")
    }

    // Multiple Checkpoint function

    @IBAction func checkpoint1Changed(_ sender: Any) {
        var grade = 0.0
        if checkpoint1Switch.isOn {
            grade = 50.0
        }
        self.updateGrade(grade, markingScheme: "multipleCheckpoint")
    }

    @IBAction func checkpoint2Changed(_ sender: Any) {
        var grade = 50.0
        if checkpoint2Switch.isOn {
            grade = 100.0
        }
        self.updateGrade(grade, markingScheme: "multipleCheckpoint")
    }

    // Grade Level HD changed function
    // https://stackoverflow.com/questions/30545198/swift-handle-action-on-segmented-control
    @IBAction func gradeHDValueChanged(_ sender: Any) {
        var grade = 0.0
        switch segmentHDGradeLevel.selectedSegmentIndex {
        case 0:
            grade = 100.0
        case 1:
            grade = 80.0
        case 2:
            grade = 70.0
        case 3:
            grade = 60.0
        case 4:
            grade = 50.0
        case 5:
            grade = 0.0
        default: break
        }
        self.updateGrade(grade, markingScheme: "HDGradeLevel")
    }

    // Grade Level A changed function
    // https://stackoverflow.com/questions/30545198/swift-handle-action-on-segmented-control
    @IBAction func gradeAValueChanged(_ sender: Any) {
        var grade = 0.0
        switch segmentAGradeLevel.selectedSegmentIndex {
        case 0:
            grade = 100.0
        case 1:
            grade = 80.0
        case 2:
            grade = 70.0
        case 3:
            grade = 60.0
        case 4:
            grade = 0.0
        default:
            break
        }
        self.updateGrade(grade, markingScheme: "AGradeLevel")
    }

    // Score out of 100 function
    @IBAction func scoreOutOfChanged(_ sender: Any) {
        if self.ScoreOutOfUpdateState {
            // Save the changes
            self.btnScoreOutOfLabel.setTitle("Update", for: .normal)
            self.displayScoreOutOf.isHidden = false
            self.scoreTF.isEnabled = false
            self.scoreTF.isHidden = true
            // Update student's score
            if let grade = Double(self.scoreTF.text ?? "0.0") {
                print(grade)
                if grade < 0.0 || grade > 100.0 {
                    let alert = UIAlertController(title: "Score out of range!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                } else {
                    self.updateGrade(grade, markingScheme: "ScoreOutOf")
                }
            } else {
                let alert = UIAlertController(title: "Please enter a valid score!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        } else {
            self.btnScoreOutOfLabel.setTitle("Save", for: .normal)
            self.displayScoreOutOf.isHidden = true
            self.scoreTF.isHidden = false
            self.scoreTF.isEnabled = true
            self.scoreTF.text = self.displayScoreOutOf.text
        }
        self.ScoreOutOfUpdateState = !self.ScoreOutOfUpdateState
    }


    // Update data and layout
    func updateGrade(_ grade: Double, markingScheme: String) {
        if let studentIndex = self.studentIndex {
            studentCollection.document(students[studentIndex].id!).updateData([
                "grades.\(selectedWeek!)": grade
                ]) { err in
                if let err = err {
                    print("Error updating ducoment:\(err)")
                } else {
                    print("Document successfully updated")
                    students[studentIndex].grades[self.selectedWeek] = grade
                    switch markingScheme {
                    case "ScoreOutOf":
                        self.displayScoreOutOf.text = String(grade)
                    case "multipleCheckpoint":
                        switch grade {
                        case 0.0:
                            self.checkpoint1Switch.isOn = false
                            self.checkpoint2Switch.isOn = false
                            self.checkpoint2Switch.isEnabled = false
                            self.checkpoint2Label.isEnabled = false
                        case 50.0:
                            self.checkpoint2Switch.isEnabled = true
                            self.checkpoint2Label.isEnabled = true
                            self.checkpoint1Switch.isOn = true
                            self.checkpoint2Switch.isOn = false
                        case 100.0:
                            self.checkpoint2Switch.isEnabled = true
                            self.checkpoint2Label.isEnabled = true
                            self.checkpoint1Switch.isOn = true
                            self.checkpoint2Switch.isOn = true
                        default:
                            break;
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}
