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
    
    var messageConfiguration = MessageConfiguration()
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var frequencySlider: UISlider!    
    @IBOutlet weak var frequencyValue: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageValidator: UILabel!
    @IBOutlet weak var messageCounter: UILabel!
    @IBOutlet weak var emailValidator: UILabel!
    @IBOutlet weak var btnAddReceiver: UIButton!
    @IBOutlet weak var emailCounter: UILabel!
    
    override func viewDidLoad() {
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        tagListView.delegate = self
        messageTextField.delegate = self
        emailTextField.delegate = self
        
//        messageCounter.text = ""
//        emailCounter.text =  ""
//        emailValidator.text = ""
//        messageValidator.text = ""
        
        categoryPicker.selectRow(messageConfiguration.category, inComponent: 0, animated: true)
        frequencySlider.value = Float(messageConfiguration.frequency)
        frequencyValue.text = String(messageConfiguration.frequency)
        messageConfiguration.sendTo.map({tagListView.addTag($0)})
        messageTextField.text = messageConfiguration.message
        btnAddReceiver.isEnabled = false
        
    }
    
    @IBAction func messageChanged(_ sender: UITextField) {
        messageValidator.text = messageTextField.text == "" ? K.errorMsgEmptyField : ""
        messageCounter.text = String(K.textFieldLength - messageTextField.text!.count)
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        emailValidator.text = !isValidEmail(emailTextField.text!) ? K.errorMsgInvalidEmail : ""
        emailCounter.text = String(K.textFieldLength - emailTextField.text!.count)
        btnAddReceiver.isEnabled = isValidEmail(emailTextField.text!)
    }
    
    @IBAction func addReceiver(_ sender: UIButton) {
        
        // If max amount of tasks reached: Exit function and show error
        guard tagListView.tagViews.count < K.maxNumberOfReceivers  else {
            return emailValidator.text = K.errorMsgMaxNumberOfReceivers
        }
        
        // If add repeated e-mail: Exit function and show error
        let currentTags = tagListView.tagViews.map({$0.currentTitle!})
        guard !currentTags.contains(emailTextField.text!) else {
            return emailValidator.text = K.errorMsgRepeatedReceiver
        }
        
        // If no errors: Add tag
        tagListView.addTag(emailTextField.text!)
        emailTextField.text = ""
        emailCounter.text = ""
        emailValidator.text = ""
        btnAddReceiver.isEnabled = false
    }
    
    @IBAction func frequencySliderChanged(_ sender: UISlider) {
        
        frequencyValue.text = "\(Int(frequencySlider.value))"
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        
        if tagListView.tagViews.count > 0 && messageTextField.text != "" {
            let db = Firestore.firestore()
            //Add document configuration to collection when button pressed
            if let messageOwner = Auth.auth().currentUser?.email {
                
                db.collection(K.FStore.MessageConfiguration.collectionName).document(messageConfiguration.docId == "" ? generateDocId : messageConfiguration.docId).setData([
                    K.FStore.MessageConfiguration.ownerField: messageOwner,
                    K.FStore.MessageConfiguration.categoryField: messageConfiguration.category,//Int(selectedCategory),
                    K.FStore.MessageConfiguration.frequencyField: Int(frequencyValue.text!)!,
                    K.FStore.MessageConfiguration.messageField: messageTextField.text!,
                    K.FStore.MessageConfiguration.dateField: Date().timeIntervalSince1970,
                    K.FStore.MessageConfiguration.sendToField: tagListView.tagViews.map({$0.currentTitle!})
                ])
                { (error) in
                    if let e = error{
                        print("\(K.errorMsgSavingData)\(e.localizedDescription)")
                    } //else {
                    //  print("Saved succesfully")
                    //                        DispatchQueue.main.async {
                    //                            self.messageTextfield.text=""
                    //                        }
                    //}
                }
            }
            super.navigationController?.popToRootViewController(animated: true)
        }
        else {
            emailValidator.text = tagListView.tagViews.count > 0 ? "" : K.errorMsgMinNumberOfReceivers
            messageValidator.text = messageTextField.text == "" ? K.errorMsgEmptyField : ""
            
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = K.emailRegExpression
        let emailPred = NSPredicate(format: K.emailFormat, emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    var generateDocId: String {
        get {
            return String((0..<K.docIdLength).map{_ in K.alphaNumericValues.randomElement()!})
        }
    }
}


//MARK: TagListViewDelegate

extension CreateUpdateMessage: TagListViewDelegate{
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
}


//MARK: UIPickerViewDelegate

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
        messageConfiguration.category = row
    }
    
}

//MARK: UITextFieldDelegate
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

