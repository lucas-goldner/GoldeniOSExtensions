//
//  ActionViewController.swift
//  Import_photo_action
//
//  Created by Lucas Goldner on 06.01.24.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers
import Flutter

class ActionViewController: UIViewController {
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let imageURL = imageURL as? URL {
                                self.imageURL = imageURL
                                self.showFlutter(imageURL: imageURL.path())
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                break
            }
        }
    }
    
    
    
    func showFlutter(imageURL: String) {
        print(imageURL)
        let flutterViewController = FlutterViewController(project: nil, initialRoute: "/importFromFlutterAction\(imageURL)", nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
    }
}
