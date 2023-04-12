//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 24.03.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet private var colorView: UIView!
    
    @IBOutlet private var redColorLabel: UILabel!
    @IBOutlet private var greenColorLabel: UILabel!
    @IBOutlet private var blueColorLabel: UILabel!
    
    @IBOutlet private var redSlider: UISlider!
    @IBOutlet private var greenSlider: UISlider!
    @IBOutlet private var blueSlider: UISlider!
    
    @IBOutlet var redSliderTF: UITextField!
    @IBOutlet var greenSliderTF: UITextField!
    @IBOutlet var blueSliderTF: UITextField!
    
    var viewColor: UIColor!
    
    unowned var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        redSliderTF.delegate = self
        greenSliderTF.delegate = self
        blueSliderTF.delegate = self
        
        colorView.layer.cornerRadius = 10
        
        colorView.backgroundColor = viewColor
        
        redSlider.value = Float(getRGBFromView().red)
        greenSlider.value = Float(getRGBFromView().green)
        blueSlider.value = Float(getRGBFromView().blue)
        
        setColor()
        setValuesToColorLabels()
        setValuesToTF()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        setColor()
        setValuesToColorLabels()
    }
    
    @IBAction private func changeColorOfView(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redColorLabel.text = string(from: redSlider)
            redSliderTF.text = string(from: redSlider)
        case greenSlider:
            greenColorLabel.text = string(from: greenSlider)
            greenSliderTF.text = string(from: greenSlider)
        default:
            blueColorLabel.text = string(from: blueSlider)
            blueSliderTF.text = string(from: blueSlider)
        }
    }
    
    @IBAction func doneButtonPressed() {
        if let color = colorView.backgroundColor {
            delegate.setColor(viewColor: color)
        }
        
        dismiss(animated: true)
    }
    
    private func getRGBFromView() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        viewColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValuesToColorLabels() {
        redColorLabel.text = string(from: redSlider)
        greenColorLabel.text = string(from: greenSlider)
        blueColorLabel.text = string(from: blueSlider)
    }
    
    private func setValuesToTF() {
        redSliderTF.text = string(from: redSlider)
        greenSliderTF.text = string(from: greenSlider)
        blueSliderTF.text = string(from: blueSlider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        
        if textField.tag == 0 {
            redSlider.setValue(numberValue, animated: true)
        } else if textField.tag == 1 {
            greenSlider.setValue(numberValue, animated: true)
        } else if textField.tag == 2 {
            blueSlider.setValue(numberValue, animated: true)
        }
        
        setColor()
        setValuesToColorLabels()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for sliderTextField in [redSliderTF, greenSliderTF, blueSliderTF] {
            if textField == sliderTextField {
                textFieldDidEndEditing(textField)
            }
        }
        
        return true
    }
}
