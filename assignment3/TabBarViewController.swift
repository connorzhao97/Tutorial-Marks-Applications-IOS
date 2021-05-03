//
//  TabBarViewController.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default tab page
        self.selectedIndex = 1

//        let summaryViewController = StudentListTableViewController()
//        let summaryViewController2 = StudentListTableViewController()
//
//        let tabBarController = TabBarViewController()
//        tabBarController.viewControllers=[summaryViewController,summaryViewController2]
//
//        tabBarController.selectedIndex=1
//

        // Do any additional setup after loading the view.
//        let tabBarController = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
//
//        tabBarController.selectedViewController  = tabBarController.viewControllers![0]
//        present(tabBarController, animated: true, completion: nil)
    }

}
