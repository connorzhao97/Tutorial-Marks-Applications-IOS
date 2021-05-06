//
//  MarkingStudentTableViewCell.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class MarkingStudentTableViewCell: UITableViewCell, UIPickerViewDelegate & UIPickerViewDataSource {
    // Views
    @IBOutlet var attendanceView: UIView!
    @IBOutlet var gradeHDView: UIView!

    // Labels
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!

    // Marking Scheme
    @IBOutlet var attendanceCheck: UISwitch!
    @IBOutlet var btnHDGradeLevel: UIButton!
    

    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var grade: Double! = 0.0
    var selectedWeek: String!
    var selectedScheme: String!
    var studentIndex: Int?
    var HDGradeIndex = 0

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
        self.updateGrade(grade, markingScheme: "Attendance")
    }

    //https://www.youtube.com/watch?v=9Fy0Gc1l3VE
    @IBAction func gradeHDValueChanged(_ sender: Any) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) //create a new pick view frame
        pickerView.tag = 0
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.selectRow(self.HDGradeIndex, inComponent: 0, animated: false) // grade
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        let alert = UIAlertController(title: "Select Grade", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.popoverPresentationController?.sourceRect = pickerView.bounds

        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))

        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.HDGradeIndex = pickerView.selectedRow(inComponent: 0)
            let selectedHDGrade = HDGrades[self.HDGradeIndex]
            var grade = 0.0
            switch selectedHDGrade {
            case "HD+":
                grade = 100.0
            case "HD":
                grade = 80.0
            case "DN":
                grade = 70.0
            case "CR":
                grade = 60.0
            case "PP":
                grade = 50.0
            case "NN":
                grade = 0.0
            default: break
            }
            self.updateGrade(grade, markingScheme: "HDGradeLevel")
        }))
        //https://stackoverflow.com/questions/30736391/presenting-a-view-controller-with-a-button-in-a-uitableviewcell-programmatically
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //https://stackoverflow.com/questions/27642164/how-to-use-two-uipickerviews-in-one-view-controller
        if pickerView.tag == 0 {
            return HDGrades.count
        } else {
            return AGrades.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))

        if pickerView.tag == 0 {
            label.text = HDGrades[row]
            label.sizeToFit()
        } else {
            label.text = AGrades[row]
            label.sizeToFit()
        }


        return label
    }
    
    // Update data and layout
    func updateGrade(_ grade:Double, markingScheme:String){
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
                    case "HDGradeLevel":
                        self.btnHDGradeLevel.setTitle(HDGrades[self.HDGradeIndex], for: .normal)
                    default:
                        break
                    }
                }
            }
        }
    }
}
