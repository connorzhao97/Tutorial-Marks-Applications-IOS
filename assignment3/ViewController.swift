//
//  ViewController.swift
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

class ViewController: UIViewController, UITableViewDelegate & UITableViewDataSource {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
//        let db = Firestore.firestore()
//        let movieCollection = db.collection("movies")
//
//        movieCollection.getDocuments() { (result, err)in
//            if let err = err {
//                print("Error getting documents: \(err)")
//
//            } else {
//                for document in result!.documents {
//                    let conversionResult = Result {
//                        try document.data (as: Movie.self)
//                    }
//
//                    switch conversionResult {
//                    case .success(let convertedDoc):
//                        if let movie = convertedDoc {
//                            print("Movie: \(movie)")
//                        } else {
//                            print("Document does not exist")
//                        }
//                    case .failure(let error):
//                        print("Error decoding movie: \(error)")
//                    }
//                }
//            }
//
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(students)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        return cell
    }

}

