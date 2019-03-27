//
//  ViewController.swift
//  Tastatur
//
//  Created by Jan  on 14/12/2018.
//  Copyright © 2018 Jan . All rights reserved.
//

/*
    For å få appen til å oppføre seg korrekt, må du ikke bruke "Stack View", kun constaraints.
    Dette vil nå virke for både Portrait og Landscape.
    Virker 100% på kun Text Field. En mindre tilpasning for å ha med et Texy View (ikke helt 100%)
*/

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var textFieldB: UITextField!
    @IBOutlet weak var textFieldC: UITextField!
    @IBOutlet weak var textViewA: UITextView!
    
    var activeField: UITextField!
    var activeTextView: UITextView!
    
    let offset: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldA.delegate = self
        textFieldB.delegate = self
        textFieldC.delegate  = self
        textViewA.delegate = self
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        // Remove observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if activeField?.frame.origin.y != nil {
        
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            let distanceToBottom = view.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            
            if keyboardRect.height > distanceToBottom {
            
                if notification.name == UIResponder.keyboardWillShowNotification ||
                    notification.name == UIResponder.keyboardWillChangeFrameNotification {
                    view.frame.origin.y = -(keyboardRect.height - distanceToBottom + offset)
                } else {
                    view.frame.origin.y = 0
                }
                
            }
        } else {
            
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            let distanceToBottom = view.frame.size.height - (activeTextView.frame.origin.y) - (activeTextView.frame.size.height)
            
            if keyboardRect.height > distanceToBottom {
                view.frame.origin.y = -(keyboardRect.height - distanceToBottom + offset)
                
            } else {
             view.frame.origin.y = 0
            }
            
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        // Necessary reset
        view.frame.origin.y = 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Necessary reset
        view.frame.origin.y = 0
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
}

