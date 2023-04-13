//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 24.03.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private var colorView: UIView!
    @IBOutlet private var colorLabels: [UILabel]!
    @IBOutlet private var sliders: [UISlider]!
    @IBOutlet private var slidersTextFields: [UITextField]!
    
    var viewColor: UIColor!
    
    unowned var delegate: SettingsViewControllerDelegate!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonToToolBar(textFields: slidersTextFields)
        
        for textField in slidersTextFields {
            textField.delegate = self
        }
        
        colorView.layer.cornerRadius = 10
        colorView.backgroundColor = viewColor
        
        for (slider, color) in zip(sliders, getRGBFromView()) {
            slider.value = Float(color)
        }
        
        setColor()
        setValuesToColorLabels()
        setValuesToTF()
    }
    
    // MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        for textField in slidersTextFields {
            guard let newValue = textField.text else { return }
            guard let numberValue = Float(newValue), (0...1).contains(numberValue) else {
                showAlert(textField: textField)
                return
            }
            
            setValuesOfSlidersWith(textField: textField, numberValue: numberValue)
        }
    }
    
    // MARK: - IB Actions
    @IBAction private func changeColorOfView(_ sender: UISlider) {
        setColor()
        switch sender.tag {
        case 0:
            colorLabels[0].text = string(from: sliders[0])
            slidersTextFields[0].text = string(from: sliders[0])
        case 1:
            colorLabels[1].text = string(from: sliders[1])
            slidersTextFields[1].text = string(from: sliders[1])
        default:
            colorLabels[2].text = string(from: sliders[2])
            slidersTextFields[2].text = string(from: sliders[2])
        }
    }
    
    @IBAction private func doneButtonPressed() {
        if let color = colorView.backgroundColor {
            delegate.setColor(color)
        }
        
        dismiss(animated: true)
    }
    
    @objc private func addActionToDoneButton() {
        for textField in slidersTextFields {
            guard let newValue = textField.text else { return }
            guard let numberValue = Float(newValue), (0...1).contains(numberValue) else {
                showAlert(textField: textField)
                return
            }
            
            setValuesOfSlidersWith(textField: textField, numberValue: numberValue)
            
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - Private funcs
    private func getRGBFromView() -> [CGFloat] {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        viewColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue]
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(sliders[0].value),
            green: CGFloat(sliders[1].value),
            blue: CGFloat(sliders[2].value),
            alpha: 1
        )
    }
    
    private func setValuesToColorLabels() {
        for (colorLabel, slider) in zip(colorLabels, sliders) {
            colorLabel.text = string(from: slider)
        }
    }
    
    private func setValuesToTF() {
        for (textField, slider) in zip(slidersTextFields, sliders) {
            textField.text = string(from: slider)
        }
    }

    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func addDoneButtonToToolBar(textFields: [UITextField]) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(addActionToDoneButton)
        )
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            doneButton
        ]
        
        for textField in textFields {
            textField.inputAccessoryView = toolbar
        }
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue), (0...1).contains(numberValue) else {
            showAlert(textField: textField)
            return
        }
        
        setValuesOfSlidersWith(textField: textField, numberValue: numberValue)
    }
    
    private func setValuesOfSlidersWith(textField: UITextField, numberValue: Float) {
        textField.text = String(format: "%.2f", numberValue)
        
        if textField.tag == 0 {
            sliders[0].setValue(numberValue, animated: true)
        } else if textField.tag == 1 {
            sliders[1].setValue(numberValue, animated: true)
        } else if textField.tag == 2 {
            sliders[2].setValue(numberValue, animated: true)
        }
        
        setColor()
        setValuesToColorLabels()
    }
    
    private func showAlert(textField: UITextField) {
        let alert = UIAlertController(
            title: "Invalid format",
            message: "Please, enter values from 0 to 1",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
