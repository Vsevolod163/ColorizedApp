//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 24.03.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet private var colorView: UIView!
 
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Public Properties
    unowned var delegate: SettingsViewControllerDelegate!
    var viewColor: UIColor!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 10
        
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        blueSlider.tintColor = .blue
        
        colorView.backgroundColor = viewColor
        
        setValue(for: redSlider, greenSlider, blueSlider)
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func rgbSlider(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        }
    }
    
    
    
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabel: label.text = string(from: redSlider)
            case greenLabel: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for colorSliders: UISlider...) {
        let ciColor = CIColor(color: viewColor)
        colorSliders.forEach { slider in
            switch slider {
            case redSlider: redSlider.value = Float(ciColor.red)
            case redSlider: greenSlider.value = Float(ciColor.green)
            default: blueSlider.value = Float(ciColor.blue)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTextField: textField.text = string(from: redSlider)
            case greenTextField: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
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
