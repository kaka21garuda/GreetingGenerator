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
    
    let lastSelectedGreeting: Variable<String> = Variable("Hello")
    
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
        
        let segmentedControlObservable: Observable<Int> = mainSegment.rx.value.asObservable()
        
        // MARK: Transformation
        // return 0 or 1
        let stateObservable: Observable<MainSegmentState> = segmentedControlObservable.map {
            (selectedIndex: Int) -> MainSegmentState in
            return MainSegmentState(rawValue: selectedIndex)!
        }
        
        // map stateObservable to covert 0 and 1 becoming False and True.
        let greetingTextFieldEnabledObservable: Observable<Bool> = stateObservable.map {
            (state: MainSegmentState) -> Bool in
            
            return state == .useTextfield
        }
        // Binding
        greetingTextFieldEnabledObservable.bindTo(customGreetingTextField.rx.isEnabled).addDisposableTo(disposeBag)
        
        let buttonsObservable: Observable<Bool> = greetingTextFieldEnabledObservable.map {
            (greetingEnabled) -> Bool in
            return !greetingEnabled
        }
        
        greetingsButton.forEach { (button) in
            buttonsObservable.bindTo(button.rx.isEnabled).addDisposableTo(disposeBag)
            
            // subscribing the button tap, instead of using IBAction.
            button.rx.tap.subscribe(onNext: { (nothing: Void) in
                self.lastSelectedGreeting.value = button.currentTitle!
            })
        }
        
        let predefineGreetingObservable: Observable<String> = lastSelectedGreeting.asObservable()
        
        let finalGreetingObservable: Observable<String> = Observable.combineLatest(
                    stateObservable,
                    greetingObservable,
                    predefineGreetingObservable,
                    nameTextObservable)
            
        { (state: MainSegmentState,
           customGreeting: String?,
           predefineGreeting: String,
           name: String?) -> String in
            
            switch state {
                case .useTextfield: return customGreeting! + ", " + name!
                case .useButton: return predefineGreeting + ", " + name!
            }
        }
        
        finalGreetingObservable.bindTo(mainLabel.rx.text).addDisposableTo(disposeBag)
    }
}
