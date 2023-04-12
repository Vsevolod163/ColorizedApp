//
//  StartViewController.swift
//  ColorizedApp
//
//  Created by Vsevolod Lashin on 12.04.2023.
//

import UIKit

final class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        
        settingsVC.viewColor = view.backgroundColor
    }
}
