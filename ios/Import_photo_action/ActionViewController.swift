//
//  ActionViewController.swift
//  Import_photo_action
//
//  Created by Lucas Goldner on 06.01.24.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    var hostAppBundleIdentifier = "com.lucas-goldner.golden-ios-extensions"
    let sharedKey = "ImportKey"
    var appGroupId = "group.com.lucas-goldner.golden-ios-extensions"
    var imageURL: URL?
    var importedMedia: [ImportedFile] = []
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIds()
        
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongImageView = weakImageView {
                                if let imageURL = imageURL as? URL {
                                    self.imageURL = imageURL
                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                                }
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

    @IBAction func done() {
        guard let url = self.imageURL else {
            self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            return
        }
        let fileName = "\(url.deletingPathExtension().lastPathComponent).\(url.pathExtension)"
        let newPath = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: self.appGroupId)!
            .appendingPathComponent(fileName)
        let copied = self.copyFile(at: url, to: newPath)
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
        self.redirectToHostApp()
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
    
    private func loadIds() {
        let shareExtensionAppBundleIdentifier = Bundle.main.bundleIdentifier!;
    
        let lastIndexOfPoint = shareExtensionAppBundleIdentifier.lastIndex(of: ".");
        hostAppBundleIdentifier = String(shareExtensionAppBundleIdentifier[..<lastIndexOfPoint!]);

        appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(hostAppBundleIdentifier)";
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

}

class ImportedFile: Codable {
    var path: String;
    var name: String;
    
    init(path: String, name: String) {
        self.path = path
        self.name = name
    }
}
