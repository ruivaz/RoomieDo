//
//  NewTaskView.swift
//  RoomieDo
//
//  Created by Jenelle Feole on 1/6/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import UIKit

class NewTaskView: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    var task: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newTask = taskName.text {
            task = newTask
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
