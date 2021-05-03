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

    var alertLoading: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Add student
    @IBAction func addNewStudent(_ sender: Any) {

        var addable = true

        guard let studentName = self.studentNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return addable = false
        }

        guard let studentID = self.studentIDTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return addable = false
        }

        if studentName.isEmpty || studentID.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Student name or ID cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            addable = false
        }


        if addable {
            // If student name or ID are not empty
            var student = Student(studentName: studentName, studentID: Int(studentID) ?? -1, avatarUrl: "", grades: ["week1": 0.0, "week2":0.0, "week3":0.0, "week4":0.0, "week5":0.0, "week6":0.0, "week7":0.0, "week8":0.0, "week9":0.0, "week10":0.0, "week11":0.0, "week12":0.0])

            // https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
            // Creating loading indicator
            self.alertLoading = UIAlertController(title: nil, message: "Adding...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            self.alertLoading!.view.addSubview(loadingIndicator)
            present(self.alertLoading!, animated: true, completion: nil)


            do {
                var ref: DocumentReference? = nil
                try ref = studentCollection.addDocument(from: student) { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        self.alertLoading!.dismiss(animated: false, completion: {
                            student.id = ref!.documentID
                            students.append(student)
                            let alert = UIAlertController(title: "", message: "Add the new student successfully!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self.performSegue(withIdentifier: "addStudentSegue", sender: sender)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }
            } catch let error {
                print("Error writing student to Firestore: \(error)")
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
