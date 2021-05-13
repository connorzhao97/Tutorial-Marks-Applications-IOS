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
    @IBOutlet var gradeAView: UIView!
    @IBOutlet var scoreOutOfView: UIView!
    @IBOutlet var multipleCheckpointView: UIView!
    
    
    // Labels
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!

    // Marking Scheme
    @IBOutlet var attendanceCheck: UISwitch!
    @IBOutlet var btnHDGradeLevel: UIButton!
    @IBOutlet var btnAGradeLevel: UIButton!
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
    var HDGradeIndex = 0
    var AGradeIndex = 0
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
        if checkpoint1Switch.isOn{
            grade = 50.0
        }
        self.updateGrade(grade, markingScheme: "multipleCheckpoint")
    }
    
    @IBAction func checkpoint2Changed(_ sender: Any) {
        var grade = 50.0
        if checkpoint2Switch.isOn{
            grade=100.0
        }
        self.updateGrade(grade, markingScheme: "multipleCheckpoint")
    }
    
    
    

    // Grade Level HD changed function
    //https://www.youtube.com/watch?v=9Fy0Gc1l3VE
    @IBAction func gradeHDValueChanged(_ sender: Any) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) //create a new pick view frame
        // Determine which picker to show
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
    // Grade Level A changed function
    @IBAction func gradeAValueChanged(_ sender: Any) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) //create a new pick view frame
        // Determine which picker to show
        pickerView.tag = 1
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(self.AGradeIndex, inComponent: 0, animated: false) // grade
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        let alert = UIAlertController(title: "Select Grade", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.popoverPresentationController?.sourceRect = pickerView.bounds

        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.AGradeIndex = pickerView.selectedRow(inComponent: 0)
            let selectedHDGrade = AGrades[self.AGradeIndex]
            var grade = 0.0
            switch selectedHDGrade {
            case "A":
                grade = 100.0
            case "B":
                grade = 80.0
            case "C":
                grade = 70.0
            case "D":
                grade = 60.0
            case "F":
                grade = 0.0
            default: break
            }
            self.updateGrade(grade, markingScheme: "AGradeLevel")
        }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // Score out of 100 function
    @IBAction func scoreOutOfChanged(_ sender: Any) {
        if self.ScoreOutOfUpdateState{
            // Save the changes
            self.btnScoreOutOfLabel.setTitle("Update", for: .normal)
            self.displayScoreOutOf.isHidden=false
            self.scoreTF.isEnabled=false
            self.scoreTF.isHidden=true
            // Update student's score
            if let grade  = Double(self.scoreTF.text ?? "0.0"){
                print(grade)
                if grade < 0.0 || grade > 100.0{
                    let alert = UIAlertController(title: "Score out of range!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }else{
                    self.updateGrade(grade, markingScheme: "ScoreOutOf")
                }
            }else{
                let alert = UIAlertController(title: "Please enter a valid score!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }else{
            self.btnScoreOutOfLabel.setTitle("Save", for: .normal)
            self.displayScoreOutOf.isHidden=true
            self.scoreTF.isHidden=false
            self.scoreTF.isEnabled=true
            self.scoreTF.text = self.displayScoreOutOf.text
        }
        self.ScoreOutOfUpdateState = !self.ScoreOutOfUpdateState
    }
    
    
    // MARK: Picker View
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
                    case "AGradeLevel":
                        self.btnAGradeLevel.setTitle(AGrades[self.AGradeIndex], for: .normal)
                    case "ScoreOutOf":
                        self.displayScoreOutOf.text = String(grade)
                    case "multipleCheckpoint":
                        switch grade {
                        case 0.0:
                            self.checkpoint1Switch.isOn=false
                            self.checkpoint2Switch.isOn=false
                            self.checkpoint2Switch.isEnabled=false
                            self.checkpoint2Label.isEnabled=false
                        case 50.0:
                            self.checkpoint2Switch.isEnabled=true
                            self.checkpoint2Label.isEnabled=true
                            self.checkpoint1Switch.isOn=true
                            self.checkpoint2Switch.isOn=false
                        case 100.0:
                            self.checkpoint2Switch.isEnabled=true
                            self.checkpoint2Label.isEnabled=true
                            self.checkpoint1Switch.isOn=true
                            self.checkpoint2Switch.isOn=true
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
