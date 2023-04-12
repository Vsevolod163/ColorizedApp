//
//  StartViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 12.04.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func setColor(viewColor: UIColor)
}

final class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        
        settingsVC.viewColor = view.backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - SettingsViewControllerDeligate
extension StartViewController: SettingsViewControllerDelegate {
    func setColor(viewColor: UIColor) {
        view.backgroundColor = viewColor
    }
}
