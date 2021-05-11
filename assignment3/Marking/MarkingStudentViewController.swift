//
//  MarkingStudentViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class MarkingStudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate & UIPickerViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectedWeekLabel: UILabel!
    @IBOutlet var selectedMarkingSchemeLabel: UILabel!

    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedMarkingSchemeIndex: Int = 0
    var selectedWeekIndex: Int = 0
    var selectedWeek: String = "week1"
    var selectedMarkingScheme: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // MARK: - Database Operations
        // Get all student data
        studentCollection.order(by: "studentID").getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")

            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Student.self)
                    }

                    switch conversionResult {
                    case .success(let convertedDoc):
                        if var student = convertedDoc {
                            student.id = document.documentID
                            students.append(student)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding movie: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }

        // Get marking schemes, if marking schemes do not exist, create one
        markingSchemeCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let result = result {
                    if result.count == 0 {
                        // Add new marking scheme
                        do {
                            var ref: DocumentReference? = nil
                            try ref = markingSchemeCollection.addDocument(from: markingScheme) { (err) in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    markingScheme.id = ref!.documentID
                                }
                            }
                        } catch let err {
                            print(err)
                        }
                    } else {
                        let conversionResult = Result {
                            try result.documents[0].data(as: MarkingScheme.self)
                        }
                        switch conversionResult {
                        case .success(let convertedDoc):
                            if let schemes = convertedDoc {
                                markingScheme = schemes
                                markingScheme.id = result.documents[0].documentID
                                self.selectedWeekLabel.text = weeks[0]
                                self.selectedMarkingSchemeLabel.text = markingScheme.schemes[weeks[0]]
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let err):
                            print("Error decoding movie: \(err)")
                        }
                    }

                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Picker View functions
    //https://www.youtube.com/watch?v=9Fy0Gc1l3VE

    @IBAction func popUpPicker(_ sender: Any) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) //create a new pick view frame
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.selectRow(self.selectedWeekIndex, inComponent: 0, animated: false)

        var initMarkingScheme = 0
        if let markingscheme = markingScheme.schemes[weeks[self.selectedWeekIndex]] {
            switch markingscheme {
            case "Attendance":
                initMarkingScheme = 0
            case "Multiple Checkpoints":
                initMarkingScheme = 1
            case "Score out of 100":
                initMarkingScheme = 2
            case "Grade Level (HD)":
                initMarkingScheme = 3
            case "Grade Level (A)":
                initMarkingScheme = 4
            default:
                initMarkingScheme = 0
            }
            pickerView.selectRow(initMarkingScheme, inComponent: 1, animated: false)
        }

        vc.view.addSubview(pickerView)

        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true


        let alert = UIAlertController(title: "Select Week", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.popoverPresentationController?.sourceRect = pickerView.bounds

        alert.setValue(vc, forKey: "contentViewController")

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))

        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedWeekIndex = pickerView.selectedRow(inComponent: 0)
            self.selectedMarkingSchemeIndex = pickerView.selectedRow(inComponent: 1)

            self.selectedWeek = weeks[self.selectedWeekIndex]
            self.selectedMarkingScheme = schemes[self.selectedMarkingSchemeIndex]

            self.selectedWeekLabel.text = self.selectedWeek
            self.selectedMarkingSchemeLabel.text = self.selectedMarkingScheme
            
            // Reload data after selecting weeks or marking schemes
            self.tableView.reloadData()

            // Change marking scheme
            if self.selectedMarkingScheme != markingScheme.schemes[self.selectedWeek] {
                markingSchemeCollection.document(markingScheme.id!).updateData(["schemes.\(self.selectedWeek)": self.selectedMarkingScheme]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.selectedMarkingSchemeLabel.text = self.selectedMarkingScheme
                        markingScheme.schemes[self.selectedWeek] = self.selectedMarkingScheme
                        self.tableView.reloadData()
                        //TODO: Set all score to 0
                    }
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return weeks.count
        }
        return schemes.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))

        switch component {
        case 0:
            label.text = weeks[row]
            label.sizeToFit()
        case 1:
            label.text = schemes[row]
            label.sizeToFit()
        default:
            label.text = ""
        }

        return label
    }
    // Detect week change, and change the related marking scheme
    // https://stackoverflow.com/questions/2565805/how-to-detect-changes-on-uipickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            var changedMarkingScheme = 0
            if let markingscheme = markingScheme.schemes[weeks[row]] {
                switch markingscheme {
                case "Attendance":
                    changedMarkingScheme = 0
                case "Multiple Checkpoints":
                    changedMarkingScheme = 1
                case "Score out of 100":
                    changedMarkingScheme = 2
                case "Grade Level (HD)":
                    changedMarkingScheme = 3
                case "Grade Level (A)":
                    changedMarkingScheme = 4
                default:
                    changedMarkingScheme = 0
                }
                pickerView.selectRow(changedMarkingScheme, inComponent: 1, animated: true)
            }
        }
    }

    // MARK: - Table View functions

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkingStudentTableViewCell", for: indexPath)

        let student = students[indexPath.row]

        if let studentCell = cell as? MarkingStudentTableViewCell {
            // studentCell.attendanceView.isHidden=true
            studentCell.studentNameLabel.text = student.studentName
            studentCell.studentIDLabel.text = String(student.studentID)

            studentCell.grade = student.grades[self.selectedWeek] ?? 0.0
            studentCell.studentIndex = indexPath.row

            studentCell.selectedWeek = self.selectedWeek
            studentCell.selectedScheme = markingScheme.schemes[self.selectedWeek]

            switch studentCell.selectedScheme {
            case "Attendance":
                studentCell.attendanceView.isHidden = false
                studentCell.gradeHDView.isHidden = true
                studentCell.gradeAView.isHidden = true
                studentCell.scoreOutOfView.isHidden = true
                if studentCell.grade == 0.0 {
                    studentCell.attendanceCheck.isOn = false
                } else if studentCell.grade == 100.0 {
                    studentCell.attendanceCheck.isOn = true
                }
            case "Grade Level (HD)":
                studentCell.attendanceView.isHidden = true
                studentCell.gradeHDView.isHidden = false
                studentCell.gradeAView.isHidden = true
                studentCell.scoreOutOfView.isHidden = true
                switch studentCell.grade {
                case 100:
                    studentCell.HDGradeIndex = 0
                    studentCell.btnHDGradeLevel.setTitle("HD+", for: .normal)
                case 80:
                    studentCell.HDGradeIndex = 1
                    studentCell.btnHDGradeLevel.setTitle("HD", for: .normal)
                case 70:
                    studentCell.HDGradeIndex = 2
                    studentCell.btnHDGradeLevel.setTitle("DN", for: .normal)
                case 60:
                    studentCell.HDGradeIndex = 3
                    studentCell.btnHDGradeLevel.setTitle("CR", for: .normal)
                case 50:
                    studentCell.HDGradeIndex = 4
                    studentCell.btnHDGradeLevel.setTitle("PP", for: .normal)
                case 0:
                    studentCell.HDGradeIndex = 5
                    studentCell.btnHDGradeLevel.setTitle("NN", for: .normal)
                default:
                    break
                }
            case "Grade Level (A)":
                studentCell.attendanceView.isHidden = true
                studentCell.gradeHDView.isHidden = true
                studentCell.gradeAView.isHidden = false
                studentCell.scoreOutOfView.isHidden = true
                switch studentCell.grade {
                case 100:
                    studentCell.AGradeIndex = 0
                    studentCell.btnAGradeLevel.setTitle("A", for: .normal)
                case 80:
                    studentCell.AGradeIndex = 1
                    studentCell.btnAGradeLevel.setTitle("B", for: .normal)
                case 70:
                    studentCell.AGradeIndex = 2
                    studentCell.btnAGradeLevel.setTitle("C", for: .normal)
                case 60:
                    studentCell.AGradeIndex = 3
                    studentCell.btnAGradeLevel.setTitle("D", for: .normal)
                case 0:
                    studentCell.AGradeIndex = 4
                    studentCell.btnAGradeLevel.setTitle("F", for: .normal)
                default:
                    break;
                }
            case "Score out of 100":
                studentCell.attendanceView.isHidden = true
                studentCell.gradeHDView.isHidden = true
                studentCell.gradeAView.isHidden = true
                studentCell.scoreOutOfView.isHidden = false
                studentCell.displayScoreOutOf.text = String(studentCell.grade)
            default: break
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
