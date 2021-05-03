//
//  WeeklySummaryViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

//let db = Firestore.firestore()
//let studentCollection = db.collection("ios_students")
//public var students = [Student]()

class WeeklySummaryViewController: UIViewController, UITableViewDelegate & UITableViewDataSource {

    @IBOutlet var markingScheme: UILabel!
    @IBOutlet var summaryGrade: UILabel!
    @IBOutlet var tableView: UITableView!

    var selectedWeek: String! = "week1"


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self


    }

    @IBAction func btnSelectWeek(_ sender: Any) {

    }

    override func viewWillAppear(_ animated: Bool) {

        var grade = 0.0
        for student in students {
            grade += student.grades["\(selectedWeek!)"] ?? 0.0
        }

        self.summaryGrade.text = String(format:"%.2f",grade/Double(students.count))

        self.tableView.reloadData()
    }



    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklySummaryTableViewCell", for: indexPath)

        let student = students[indexPath.row]

        if let studentCell = cell as? WeeklySummaryTableViewCell {
            studentCell.studentNameLabel.text = student.studentName
            studentCell.studentIDLabel.text = String(student.studentID)
            studentCell.studentGradeLabel.text = String(student.grades["\(selectedWeek!)"] ?? 0.0)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

