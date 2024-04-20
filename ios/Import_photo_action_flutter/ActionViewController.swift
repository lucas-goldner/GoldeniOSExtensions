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
    var hostAppBundleIdentifier = "com.lucas-goldner.golden-ios-extensions"
    let sharedKey = "ImportKey"
    var appGroupId = "group.com.lucas-goldner.golden-ios-extensions"
    var imageURL: URL?
    var importedMedia: [ImportedFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIds()
        
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
        let flutterViewController = FlutterViewController(project: nil, initialRoute: "/importFromFlutterAction\(imageURL)", nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
        setupMethodChannel(controller: flutterViewController)
    }
    
    func setupMethodChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "com.lucas-goldner.golden-ios-extensions/flutterImport", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { (call, result) in
            if call.method == "openAppWithImagePath" {
                if let imagePath = call.arguments as? String {
                    print("Received image path: \(imagePath)")
                    let imageURL = URL(string: imagePath)
                    self.copyImageAndOpenApp(imageURL: imageURL!)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path not sent from Flutter", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func copyImageAndOpenApp(imageURL: URL) {
        self.copyImage(imageURL: imageURL)
        self.redirectToHostApp()
    }
    
    private func copyImage(imageURL: URL) {
        let fileName = "\(imageURL.deletingPathExtension().lastPathComponent).\(imageURL.pathExtension)"
        let newPath = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: self.appGroupId)!
            .appendingPathComponent(fileName)
        let copied = self.copyFile(at: imageURL, to: newPath)
        if (copied) {
            let sharedFile = ImportedFile(
                path: newPath.absoluteString,
                name: fileName
            )
            self.importedMedia.append(sharedFile)
        }
        
        let userDefaults = UserDefaults(suiteName: self.appGroupId)
        userDefaults?.set(self.toData(data: self.importedMedia), forKey: self.sharedKey)
        userDefaults?.synchronize()
    }
    
    private func redirectToHostApp() {
        let url = URL(string: "ImportMedia-\(hostAppBundleIdentifier)://dataUrl=\(sharedKey)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")

        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func toData(data: [ImportedFile]) -> Data {
       let encodedData = try? JSONEncoder().encode(data)
       return encodedData!
    }
    
    func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
    
    private func loadIds() {
        let shareExtensionAppBundleIdentifier = Bundle.main.bundleIdentifier!;
        let lastIndexOfPoint = shareExtensionAppBundleIdentifier.lastIndex(of: ".");
        hostAppBundleIdentifier = String(shareExtensionAppBundleIdentifier[..<lastIndexOfPoint!]);
        appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(hostAppBundleIdentifier)";
    }
}

class ImportedFile: Codable {
    var path: String;
    var name: String;
    
    init(path: String, name: String) {
        self.path = path
        self.name = name
    }
}
