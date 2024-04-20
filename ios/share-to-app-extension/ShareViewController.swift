//
//  ShareViewController.swift
//  share-to-app-extension
//
//  Created by Lucas Goldner on 19.04.24.
//

import MobileCoreServices
import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    var appGroupId = "group.com.lucas-goldner.golden-ios-extensions"
    var hostAppBundleIdentifier = "com.lucas-goldner.golden-ios-extensions"
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBAction func doneButton(_ sender: Any) {
        if let content = extensionContext?.inputItems[0] as? NSExtensionItem,
           let contents = content.attachments {
            for (_, attachment) in (contents).enumerated() {
                if attachment.hasItemConformingToTypeIdentifier(UTType.url.description) {
                    attachment.loadItem(forTypeIdentifier: UTType.url.description, options: nil) { (url, error) in
                        if let shareURL = url as? URL {
                            let url = URL(string: "ShareLink-\(self.hostAppBundleIdentifier)://shareURL/url=\(shareURL)&description=\(self.descriptionTextField.text ?? "")")
                            
                            var responder = self as UIResponder?
                            let selectorOpenURL = sel_registerName("openURL:")

                            while (responder != nil) {
                                if (responder?.responds(to: selectorOpenURL))! {
                                    let _ = responder?.perform(selectorOpenURL, with: url)
                                }
                                responder = responder!.next
                            }
                            self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
                        }
                    }
                }
            }
        }
        
        extensionContext?.completeRequest(returningItems: [])
    }
}


