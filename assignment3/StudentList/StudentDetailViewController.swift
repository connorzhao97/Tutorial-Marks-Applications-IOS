//
//  StudentDetailViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class StudentDetailViewController: UIViewController,UIImagePickerControllerDelegate, UITableViewDelegate, UINavigationControllerDelegate & UITableViewDataSource {

    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var studentIDTF: UITextField!
    @IBOutlet var summaryGradeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var studentAvatar: UIImageView!
    

    var student: Student?
    var studentIndex: Int?
    var alertLoading: UIAlertController?
    var avatarData: Data? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        //https://www.codingexplorer.com/getting-started-uitableview-swift/
        tableView.delegate = self
        tableView.dataSource = self
        if let displayStudent = student {
            studentNameTF.text = displayStudent.studentName
            studentIDTF.text = String(displayStudent.studentID)
            
            // Display student's image
            // https://stackoverflow.com/questions/44780937/storing-and-retrieving-image-in-sqlite-with-swift
            if let avatarData = displayStudent.avatar{
                let dataDecoded = Data(base64Encoded:avatarData, options: .ignoreUnknownCharacters)
                studentAvatar.image = UIImage(data: dataDecoded!)
            }else{
                studentAvatar.image = UIImage(systemName: "person.fill")
            }
          

            var summaryGrade = 0.0
            for week in weeks {
                summaryGrade += displayStudent.grades[week] ?? 0.0
            }
            summaryGradeLabel.text = String(format: "%.2f", summaryGrade) + "/1200 (" + String(format: "%.2f", summaryGrade / 12.0) + "%)"
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
            
            if let avatarData = avatarData{
                student!.avatar = avatarData
            }

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

    @IBAction func shareGrades(_ sender: Any) {
        if let student = student {
            var summaryGrade = 0.0
            for week in weeks {
                summaryGrade += student.grades[week] ?? 0.0
            }
            let content = """
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
                Summary Grade: \(String(format: "%.2f", summaryGrade))/1200 (\(String(format: "%.2f", summaryGrade / 12.0)) %).
                """
            let shareViewController = UIActivityViewController(activityItems: [content], applicationActivities: [])
            present(shareViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func takeAPicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }
    
    // MARK: - Image Picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller
        // Original Image is too large so firebase cannot save
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            studentAvatar.image = image
            
            //https://stackoverflow.com/questions/44780937/storing-and-retrieving-image-in-sqlite-with-swift
            //https://developer.apple.com/documentation/uikit/uiimage/1624115-jpegdata
            let imageData = image.jpegData(compressionQuality: 0)
           avatarData = imageData?.base64EncodedData(options: .lineLength64Characters)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
