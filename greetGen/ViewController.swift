//
//  ViewController.swift
//  greetGen
//
//  Created by Buka Cakrawala on 1/25/17.
//  Copyright © 2017 Buka Cakrawala. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum MainSegmentState: Int {
    case useButton
    case useTextfield
}

enum TextFieldTag: Int {
    case greetingTextField
    case nameTextField
}

class ViewController: UIViewController {
    
    // disposeBag variable prevent memory leak while binding.
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    
    @IBOutlet weak var customGreetingTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet var greetingsButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nameTextObservable: Observable<String?> = nameTextField.rx.text.asObservable()
        let greetingObservable: Observable<String?> = customGreetingTextField.rx.text.asObservable()
        
        let greetingWithNameObservable: Observable<String> = Observable.combineLatest(nameTextObservable, greetingObservable) { (string1: String?, string2: String?) in
            
            return string2! + ", " + string1!
        }
        greetingWithNameObservable.bindTo(mainLabel.rx.text).addDisposableTo(disposeBag)
        
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


}

