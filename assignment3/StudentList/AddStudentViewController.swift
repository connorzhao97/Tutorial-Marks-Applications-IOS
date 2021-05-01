//
//  AddStudentViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AddStudentViewController: UIViewController {

    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var studentIDTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addNewStudent(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Adding..."
        
        var addable = true

        if let studentName = self.studentNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            // Check whether studnet name is empty or not
            if studentName.isEmpty {
                (sender as! UIBarButtonItem).title = "Add"
                let alert = UIAlertController(title: "Alert", message: "Student name cannot be empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let studentID = self.studentIDTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    // Check whether studnet ID is empty or not
                    if studentID.isEmpty {
                        (sender as! UIBarButtonItem).title = "Add"
                        let alert = UIAlertController(title: "Alert", message: "Student ID cannot be empty!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // If student name or ID are not empty
                        let student = Student(studentName: studentName, studentID: Int(studentID) ?? -1, avatarUrl: "", grades: Grades())

                        do {
                            try studentCollection.addDocument(from: student) { (err) in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    students.append(student)
                                    let alert = UIAlertController(title: "", message: "Add the new student successfully!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                        self.performSegue(withIdentifier: "addStudentSegue", sender: sender)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        } catch let error {
                            print("Error writing student to Firestore: \(error)")
                        }
                    }
                }

            }

        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
