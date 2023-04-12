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
    
    var viewColor: UIColor!
    
    unowned var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.layer.cornerRadius = 10
        
        colorView.backgroundColor = viewColor
        
        redSlider.value = Float(getRGBFromView().red)
        greenSlider.value = Float(getRGBFromView().green)
        blueSlider.value = Float(getRGBFromView().blue)
        
        redColorLabel.text = string(from: redSlider)
        greenColorLabel.text = string(from: greenSlider)
        blueColorLabel.text = string(from: blueSlider)
    }
    
    @IBAction private func changeColorOfView(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redColorLabel.text = string(from: redSlider)
        case greenSlider:
            greenColorLabel.text = string(from: greenSlider)
        default:
            blueColorLabel.text = string(from: blueSlider)
        }
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
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    @IBAction func doneButtonPressed() {
        if let color = colorView.backgroundColor {
            delegate.setColor(viewColor: color)
        }
        
        dismiss(animated: true)
    }
    
}

