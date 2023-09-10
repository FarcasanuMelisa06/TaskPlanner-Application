//
//  NewTaskViewController.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 31.07.2023.
//

import Foundation
import UIKit

class NewTaskViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var saveData: UIButton!
    
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    
    @IBOutlet weak var textFieldStatus: UILabel!
    
    
    @IBAction func buttonSave(_ sender: Any) {
        let service = AppService()
        Task(priority: .background) {
            let result = await service.addTasks(title: textFieldTitle.text ?? "" , description: textFieldDescription.text ?? "", priority: textField.text ?? "", dueDate: textFieldDate.text ?? "" , status: textFieldStatus.text ?? "")
            switch result {
            case .success(let response):
                print("Adaugare cu succes")
                performSegue(withIdentifier: "goToTasksSegue", sender: nil)
            case .failure(let error):
                print("Eroare \(error)")
            }
        }
    
  
    }
    
    let options = ["Low", "High", "Medium"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pentru tastatura
        self.setupHideKeyboardOnTap()
        
        textField.layer.borderWidth = 0.2
        textFieldTitle.layer.borderWidth = 0.2
        textFieldDescription.layer.borderWidth = 0.2
        textFieldDate.layer.borderWidth = 0.2
        
        textField.layer.cornerRadius = 5
        textFieldTitle.layer.cornerRadius = 5
        textFieldDescription.layer.cornerRadius = 5
        textFieldDate.layer.cornerRadius = 5
        
        
        if let saveButton = saveData {
            saveButton.customizeButton()
            view.addSubview(saveButton)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Setează modul de afișare al datei pe doar ziua, luna și anul
        datePicker.datePickerMode = .date
        
        // Adaugă un target pentru evenimentul de schimbare a valorii date picker-ului
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    // Implementarea metodelor delegate și data source pentru UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = options[row]
    }
    
    // Funcție apelată când utilizatorul schimbă valoarea date picker-ului
        @objc func datePickerValueChanged(_ sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            textFieldDate.text = dateFormatter.string(from: sender.date)
        }
    

}
