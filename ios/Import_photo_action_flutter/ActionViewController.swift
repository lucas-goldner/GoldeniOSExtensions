//
//  ActionViewController.swift
//  Import_photo_action
//
//  Created by Lucas Goldner on 06.01.24.
//

import UIKit
import Flutter

class ActionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showFlutter()
    }
    
    func showFlutter() {
        let flutterViewController = FlutterViewController(project: nil, initialRoute: "/importFromFlutterAction", nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
    }
}
