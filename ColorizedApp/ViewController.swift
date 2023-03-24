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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 10
    }
    
    @IBAction private func changeColorOfView(_ sender: UISlider) {
        let valueOfSlider = (round(sender.value * 100) / 100)
  
        if sender.minimumTrackTintColor == .systemPink {
            redColorLabel.text = valueOfSlider.formatted()
            colorView.backgroundColor = .systemRed
            colorView.alpha = CGFloat(valueOfSlider)
        } else if sender.minimumTrackTintColor == .systemGreen {
            greenColorLabel.text = valueOfSlider.formatted()
            colorView.backgroundColor = .systemGreen
            colorView.alpha = CGFloat(valueOfSlider)
        } else if sender.minimumTrackTintColor == .systemBlue {
            blueColorLabel.text = valueOfSlider.formatted()
            colorView.backgroundColor = .systemBlue
            colorView.alpha = CGFloat(valueOfSlider)
        }
    }
}

