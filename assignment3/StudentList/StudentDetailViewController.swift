//
//  StudentDetailViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 1/5/21.
//

import UIKit

class StudentDetailViewController: UIViewController {

    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var studentIDTF: UITextField!

    var student: Student?
    var studentIndex: Int?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let displayStudent = student{
            studentNameTF.text = displayStudent.studentName
            studentIDTF.text  = String(displayStudent.studentID)
        }
        
     

        // Do any additional setup after loading the view.
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
