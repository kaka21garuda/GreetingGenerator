//
//  ViewController.swift
//  greetGen
//
//  Created by Buka Cakrawala on 1/25/17.
//  Copyright © 2017 Buka Cakrawala. All rights reserved.
//

import UIKit

enum MainSegmentState: Int {
    case useButton
    case useTextfield
}

enum TextFieldTag: Int {
    case greetingTextField
    case nameTextField
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    
    @IBOutlet weak var customGreetingTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet var greetingsButton: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

