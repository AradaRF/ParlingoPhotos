//
//  PhotographerPicker.swift
//  PalringoPhotos
//
//  Created by Ricardo Ferreira on 25/10/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit


class PhotographerPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var pickerData: [String]!
    var pickerTextField: UITextField!
    var selectionHandler: ((_ selectedText: String) -> Void)!
    
    init(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : @escaping(_ selectedText: String) -> Void) {
        super.init(frame: .zero)

        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        self.pickerTextField.backgroundColor = .clear
        self.selectionHandler = selectionHandler

        self.delegate = self
        self.dataSource = self

        DispatchQueue.main.async {
            if pickerData.count != 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
        
        if self.pickerTextField.text != nil && self.selectionHandler != nil {
            selectionHandler(self.pickerTextField.text!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
}

extension UITextField {
    
    func loadDropdownData(data: [String], onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.inputView = PhotographerPicker(pickerData: data, dropdownField: self, onSelect: selectionHandler)
    }
}
