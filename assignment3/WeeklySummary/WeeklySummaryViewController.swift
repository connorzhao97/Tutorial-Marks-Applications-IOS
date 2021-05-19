//
//  WeeklySummaryViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class WeeklySummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate & UIPickerViewDataSource {

    @IBOutlet var markingSchemeLabel: UILabel!
    @IBOutlet var summaryGradeLabel: UILabel!
    @IBOutlet var btnWeek: UIButton!
    @IBOutlet var tableView: UITableView!

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

    }

    override func viewWillAppear(_ animated: Bool) {
        calculateSummaryGrade()
    }


    // MARK: - Picker View functions
    //https://www.youtube.com/watch?v=9Fy0Gc1l3VE
    @IBAction func selectWeek(_ sender: Any) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) //create a new pick view frame
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.selectRow(self.selectedWeekIndex, inComponent: 0, animated: false)
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
            self.selectedWeek = weeks[self.selectedWeekIndex]
            self.btnWeek.setTitle(self.selectedWeek, for: .normal)
            self.markingSchemeLabel.text = markingScheme.schemes[self.selectedWeek]
            self.calculateSummaryGrade()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weeks.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))

        label.text = weeks[row]
        label.sizeToFit()

        return label
    }

    // MARK: - Table View functions
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
            studentCell.studentGradeLabel.text = String(student.grades["\(selectedWeek)"] ?? 0.0)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Calculate summary grade and change related text
    func calculateSummaryGrade() {
        var grade = 0.0
        for student in students {
            grade += student.grades[selectedWeek] ?? 0.0
        }
        self.summaryGradeLabel.text = String(format: "%.2f", grade / Double(students.count))
        self.markingSchemeLabel.text = markingScheme.schemes[self.selectedWeek]
        self.tableView.reloadData()
    }

}

