//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 24.03.2023.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var colorView: UIView!
    @IBOutlet private var redColorLabel: UILabel!
    @IBOutlet private var greenColorLabel: UILabel!
    @IBOutlet private var blueColorLabel: UILabel!
    
    @IBOutlet private var redSlider: UISlider!
    @IBOutlet private var greenSlider: UISlider!
    @IBOutlet private var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 10
        
        setColorValues(red: 0.05, green: 0.27, blue: 0.49)
    }
    
    @IBAction private func changeColorOfView() {
        redColorLabel.text = (round(redSlider.value * 100) / 100).formatted()
        greenColorLabel.text = (round(greenSlider.value * 100) / 100).formatted()
        blueColorLabel.text = (round(blueSlider.value * 100) / 100).formatted()
        
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setColorValues(red: Float, green: Float, blue: Float) {
        redColorLabel.text = red.formatted()
        greenColorLabel.text = green.formatted()
        blueColorLabel.text = blue.formatted()
        
        redSlider.value = red
        greenSlider.value = green
        blueSlider.value = blue
    }
}

