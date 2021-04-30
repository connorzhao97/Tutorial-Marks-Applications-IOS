//
//  ViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewController: UIViewController {

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


}

