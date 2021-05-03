//
//  StudentListTableViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class StudentListViewController: UIViewController, UITableViewDelegate & UITableViewDataSource {

    @IBOutlet var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        //https://www.codingexplorer.com/getting-started-uitableview-swift/
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell", for: indexPath)

        let student = students[indexPath.row]

        if let studentCell = cell as? StudentListTableViewCell {
            studentCell.studentNameLabel.text = student.studentName
            studentCell.studentIDLabel.text = String(student.studentID)
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

            let selectedStudent = students[indexPath.row]

            studentDetailViewController.student = selectedStudent
            studentDetailViewController.studentIndex = indexPath.row

        }
    }



}
