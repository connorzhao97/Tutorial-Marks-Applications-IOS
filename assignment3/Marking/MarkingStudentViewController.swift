//
//  MarkingStudentViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class MarkingStudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

            let selectedWeek = "week1"

            studentCell.grade = student.grades["week1"] ?? 0
            studentCell.studentIndex = indexPath.row

            studentCell.selectedWeek = selectedWeek
            studentCell.selectedScheme = "Attendance"


            if studentCell.grade == 0.0 {
                studentCell.attendanceCheck.isOn = false
            } else if studentCell.grade == 100.0 {
                studentCell.attendanceCheck.isOn = true
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
