//
//  StudentListTableViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class StudentListViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate & UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()

        //https://www.codingexplorer.com/getting-started-uitableview-swift/
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }

    override func viewWillAppear(_ animated: Bool) {
        searchStudents = students
        searchBar.text = ""
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            searchStudents = students
        } else {
            //https://www.donnywals.com/how-to-filter-an-array-in-swift/
            searchStudents = students.filter { student in
                return student.studentName.lowercased().contains(text.lowercased()) || String(student.studentID).contains(text)
            }
        }
        tableView.reloadData()
    }




    @IBAction func shareAllGrades(_ sender: Any) {
        var content = ""
        for student in students {
            var summaryGrade = 0.0
            for week in weeks {
                summaryGrade += student.grades[week] ?? 0.0
            }
            content += """
                    Student Name: \(student.studentName),
                    Student ID: \(student.studentID),
                    Week1: \(student.grades["week1"] ?? 0.0),
                    Week2: \(student.grades["week2"] ?? 0.0),
                    Week3: \(student.grades["week3"] ?? 0.0),
                    Week4: \(student.grades["week4"] ?? 0.0),
                    Week5: \(student.grades["week5"] ?? 0.0),
                    Week6: \(student.grades["week6"] ?? 0.0),
                    Week7: \(student.grades["week7"] ?? 0.0),
                    Week8: \(student.grades["week8"] ?? 0.0),
                    Week9: \(student.grades["week9"] ?? 0.0),
                    Week10: \(student.grades["week10"] ?? 0.0),
                    Week11: \(student.grades["week11"] ?? 0.0),
                    Week12: \(student.grades["week11"] ?? 0.0),
                    Summary Grade: \(String(format: "%.2f", summaryGrade))/1200 (\(String(format: "%.2f", summaryGrade / 12.0)) %).\n\n
                    """
        }
        let shareViewController = UIActivityViewController(activityItems: [content], applicationActivities: [])
        present(shareViewController, animated: true, completion: nil)
    }




    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchStudents.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell", for: indexPath)

        let student = searchStudents[indexPath.row]

        if let studentCell = cell as? StudentListTableViewCell {
            studentCell.studentNameLabel.text = student.studentName
            studentCell.studentIDLabel.text = String(student.studentID)
            // Display student's image
            // https://stackoverflow.com/questions/44780937/storing-and-retrieving-image-in-sqlite-with-swift
            if let avatarData = student.avatar {
                let dataDecoded = Data(base64Encoded: avatarData, options: .ignoreUnknownCharacters)
                studentCell.studentAvatar.image = UIImage(data: dataDecoded!)
            } else {
                studentCell.studentAvatar.image = UIImage(systemName: "person.fill")
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
//            print("good")
//        })
//        deleteAction.backgroundColor = .red
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        configuration.performsFirstActionWithFullSwipe=false
//        return configuration
//    }
//

    @IBAction func unwindToStudentList(sender: UIStoryboardSegue) {

        if sender.identifier == "saveStudentSegue" {
            // Update table view after updating student details
            if let studentDetail = sender.source as? StudentDetailViewController {
                students[studentDetail.studentIndex!] = studentDetail.student!
            }
        }
    }

    @IBAction func unwindToStudentListWithCancel(sender: UIStoryboardSegue) {

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "goToStudentDetailSegue" {
            guard let studentDetailViewController = segue.destination as? StudentDetailViewController else {
                fatalError("Unexpectd destination:\(segue.destination) ")
            }

            guard let selectedStudentCell = sender as? StudentListTableViewCell else {
                fatalError("Unexpectd sender:\(String(describing: sender)) ")
            }

            guard let indexPath = tableView.indexPath(for: selectedStudentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedStudent = searchStudents[indexPath.row]

            // Pass the original student index (not searched student list index)
            // https://developer.apple.com/documentation/swift/array/2994722-firstindex
            let originalIndex = students.firstIndex(where: { student in
                return student.id == selectedStudent.id
            })

            studentDetailViewController.student = selectedStudent
            studentDetailViewController.studentIndex = originalIndex!

            // Dismiss keyboard
            // https://stackoverflow.com/questions/29925373/how-to-make-keyboard-dismiss-when-i-press-out-of-searchbar-on-swift
            searchBar.endEditing(true)

        }
    }
}
