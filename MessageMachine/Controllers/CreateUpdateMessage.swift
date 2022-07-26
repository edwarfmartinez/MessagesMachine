//
//  CreateUpdateMessage.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 7/06/22.
//

import Foundation
import UIKit
import TagListView
import Firebase


class CreateUpdateMessage: UIViewController {

    //MARK: Outlets (Properties)

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var frequencySlider: UISlider!    
    @IBOutlet weak var frequencyValue: UILabel!
    @IBOutlet weak var tagListViewReceivers: TagListView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageValidator: UILabel!
    @IBOutlet weak var messageCounter: UILabel!
    @IBOutlet weak var receiverValidator: UILabel!
    @IBOutlet weak var btnAddReceiver: UIButton!
    @IBOutlet weak var emailCounter: UILabel!
    
    var messagesMachineManager = MessagesMachineManager()
    var messagesConfiguration = MessageConfiguration()

    override func viewDidLoad() {
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        tagListViewReceivers.delegate = self
        messageTextField.delegate = self
        emailTextField.delegate = self
        
        categoryPicker.selectRow(messagesConfiguration.category, inComponent: 0, animated: true)
        frequencySlider.value = Float(messagesConfiguration.frequency)
        frequencyValue.text = String(messagesConfiguration.frequency)
        messagesConfiguration.sendTo.map({tagListViewReceivers.addTag($0)})
        messageTextField.text = messagesConfiguration.body
        btnAddReceiver.isEnabled = false
        
        
        messageTextField.accessibilityIdentifier = "messageTextField"
        emailTextField.accessibilityIdentifier = "emailTextField"
        btnAddReceiver.accessibilityIdentifier = "btnAddReceiver"

        
        
        

    }
    
    
    
    //MARK: IBActions
    
    @IBAction func messageChanged(_ sender: UITextField) {
        messageValidator.text = messageTextField.text == "" ? K.errorMsgEmptyField : ""
        messageCounter.text = String(K.textFieldLength - messageTextField.text!.count)
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        receiverValidator.text = !isValidEmail(emailTextField.text!) ? K.errorMsgInvalidEmail : ""
        emailCounter.text = String(K.textFieldLength - emailTextField.text!.count)
        btnAddReceiver.isEnabled = isValidEmail(emailTextField.text!)
    }
    
    @IBAction func addReceiver(_ sender: UIButton) {
        
        // If add repeated e-mail: Exit function and show error
        let currentTags = tagListViewReceivers.tagViews.map({$0.currentTitle!})
        guard !currentTags.contains(emailTextField.text!) else {
            return receiverValidator.text = K.errorMsgRepeatedReceiver
        }
        
        // If max amount of receivers reached: Exit function and show error
        guard tagListViewReceivers.tagViews.count < K.maxNumberOfReceivers  else {
            return receiverValidator.text = K.errorMsgMaxNumberOfReceivers
        }
        
        // If no errors: Add tag
        tagListViewReceivers.addTag(emailTextField.text!)
        emailTextField.text = ""
        emailCounter.text = ""
        receiverValidator.text = ""
        btnAddReceiver.isEnabled = false
    }
    
    @IBAction func frequencySliderChanged(_ sender: UISlider) {
        
        frequencyValue.text = "\(Int(frequencySlider.value))"
        messagesConfiguration.frequency = Int(frequencySlider.value)
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        
        guard messageTextField.text != "" else {
            messageValidator.text = K.errorMsgEmptyField
            return
        }
        
        guard tagListViewReceivers.tagViews.count > 0 else {
            receiverValidator.text = K.errorMsgMinNumberOfReceivers
            return
        }
        
        messagesConfiguration.body = messageTextField.text!
        messagesConfiguration.sendTo = tagListViewReceivers.tagViews.map({$0.currentTitle!})
        
        //Add document configuration to collection when button pressed
        if (Auth.auth().currentUser?.email) != nil {
            messagesMachineManager.messageConfigurationCreateUpdate(message: messagesConfiguration)
            //messagesMachineManager.stopSpecificTimer(timerId: messagesConfiguration.docId)
            super.navigationController?.popToRootViewController(animated: true)
        }
    }
}

//Email validation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = K.emailRegExpression
    let emailPred = NSPredicate(format: K.emailFormat, emailRegEx)
    return emailPred.evaluate(with: email)
}

//Id generation

var generateDocId: String {
    get {
        return String((0..<K.docIdLength).map{_ in K.alphaNumericValues.randomElement()!})
    }
}

//MARK: Delegates

extension CreateUpdateMessage: TagListViewDelegate{
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
}

extension CreateUpdateMessage: UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.FStore.MessageConfiguration.categories.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //K.FStore.MessageConfiguration.category = K.FStore.MessageConfiguration.categories[row] ?? ""
        return K.FStore.MessageConfiguration.categories[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        messagesConfiguration.category = row
    }
    
}

extension CreateUpdateMessage: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        //messageValidator.text = ""
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under x characters
        return updatedText.count <= K.textFieldLength
    }
    
}

