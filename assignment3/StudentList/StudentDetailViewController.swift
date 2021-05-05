//
//  StudentDetailViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class StudentDetailViewController: UIViewController, UITableViewDelegate & UITableViewDataSource {

    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var studentIDTF: UITextField!
    @IBOutlet var summaryGradeLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    var student: Student?
    var studentIndex: Int?
    var alertLoading: UIAlertController?



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let displayStudent = student {
            studentNameTF.text = displayStudent.studentName
            studentIDTF.text = String(displayStudent.studentID)

            var summaryGrade = 0.0
            for week in weeks {
                summaryGrade += displayStudent.grades[week] ?? 0.0
            }
            summaryGradeLabel.text =  String(format: "%.2f", summaryGrade) + "/1200 (" + String(format: "%.2f", summaryGrade / 12.0) + "%)"
        }
    }


    // Update student detail
    @IBAction func saveStudent(_ sender: Any) {

        var editable = true

        guard let studentName = self.studentNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return editable = false
        }

        guard let studentID = self.studentIDTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return editable = false

        }

        if studentName.isEmpty || studentID.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Student name or ID cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            editable = false
        }

        if editable {
            student!.studentName = studentName
            student!.studentID = Int(studentID) ?? -1

            // https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
            // Creating loading indicator
            self.alertLoading = UIAlertController(title: nil, message: "Updating...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            self.alertLoading!.view.addSubview(loadingIndicator)
            present(self.alertLoading!, animated: true, completion: nil)

            do {
                try studentCollection.document(student!.id!).setData(from: student) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.alertLoading!.dismiss(animated: false, completion: {
                            let successAlert = UIAlertController(title: nil, message: "Updated the student successfully!", preferredStyle: .alert)
                            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self.performSegue(withIdentifier: "saveStudentSegue", sender: sender)
                            }))
                            self.present(successAlert, animated: true, completion: nil)
                        })
                    }
                }
            } catch {
                print("Error updating document \(error)")
            }

            //TODO: avatar url, grades
        }
    }


    @IBAction func deleteStudent(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Are you sure want to delete the studet?", message: "This action cannot be undo.", preferredStyle: .alert)

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Delete student
            studentCollection.document(self.student!.id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    if let studentIndex = self.studentIndex {
                        students.remove(at: studentIndex)
                    }

                    let successAlert = UIAlertController(title: nil, message: "Deleted the student successfully!", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "deleteStudentSegue", sender: sender)
                    }))
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
        }))

        self.present(deleteAlert, animated: true, completion: nil)
    }

    // MARK: - Table View functions
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailTableViewCell", for: indexPath)

        if let gradeCell = cell as? StudentDetailTableViewCell {
            gradeCell.detailWeekLabel.text = weeks[indexPath.row]
            gradeCell.detailGradeLabel.text = String(self.student?.grades[weeks[indexPath.row]] ?? 0.0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: "dismissSegue", sender: self)
    }

}
