//
//  ShareViewController.swift
//  share-to-app-extension_flutter
//
//  Created by Lucas Goldner on 20.04.24.
//

import UIKit
import Social
import Flutter
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    var hostAppBundleIdentifier = "com.lucas-goldner.golden-ios-extensions"
    var url: String = ""
    
    override func viewDidLoad() {
        print("This the tight one right")
        showFlutter()
        // getUrlFromExtension()
    }
    
    func getUrlFromExtension() {
        if let content = extensionContext?.inputItems[0] as? NSExtensionItem,
           let contents = content.attachments {
            for (_, attachment) in (contents).enumerated() {
                if attachment.hasItemConformingToTypeIdentifier(UTType.url.description) {
                    attachment.loadItem(forTypeIdentifier: UTType.url.description, options: nil) { (url, error) in
                        if let shareURL = url as? URL {
                            self.url = shareURL.absoluteString
                        }
                    }
                }
            }
        }
    }
    
    
    func showFlutter() {
        let flutterViewController = FlutterViewController(project: nil, initialRoute: "/shareLinkFlutterShare", nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
        // setupMethodChannel(controller: flutterViewController)
    }
    
    func setupMethodChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "com.lucas-goldner.golden-ios-extensions/shareLink", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { (call, result) in
            if call.method == "shareLinkWithDescription" {
                if let description = call.arguments as? String {
                    print("Received image path: \(description)")
                    self.openAppWithDescriptionAndLink(description: description)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path not sent from Flutter", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func openAppWithDescriptionAndLink(description: String) {
        let url = URL(string: "ShareLink-\(self.hostAppBundleIdentifier)://shareURL/url=\(self.url)&description=\(description)")

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
