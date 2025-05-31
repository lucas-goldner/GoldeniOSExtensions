import Flutter
import UIKit
import Photos
import PushKit
import flutter_callkit_incoming
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {

    
    private var schemePrefix = "ImportMedia";
    let kEventsChannelMedia: String = "com.lucas-goldner.golden-ios-extensions/import"
    
    public var initialMedia: [ImportedFile]? = nil
    public var latestMedia: [ImportedFile]? = nil
    
    private var eventSinkMedia: FlutterEventSink? = nil;
    public var eventChannel: FlutterEventChannel!;
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        self.initChannels(controller: controller)
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        self.initChannels(controller: controller)
        
        if (self.hasMatchingSchemePrefix(url: url)) {
            return self.handleUrl(url: url, setInitialData: false)
        }
        
        return super.application(app, open: url, options:options)
    }
    
    func initChannels(controller: FlutterViewController) -> Void {
        eventChannel = FlutterEventChannel(name: kEventsChannelMedia, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
    }
    
    
    // Handle updated push credentials
        func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
            print(credentials.token)
            let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
            print(deviceToken)
            //Save deviceToken to your server
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
        }
    
    // Handle incoming pushes
        func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
            print("didReceiveIncomingPushWith")
            guard type == .voIP else { return }
            
            let id = payload.dictionaryPayload["id"] as? String ?? ""
            let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
            let handle = payload.dictionaryPayload["handle"] as? String ?? ""
            let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false
            
            let data = flutter_callkit_incoming.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
            //set more data
            data.extra = ["user": "abc@123", "platform": "ios"]
            //data.iconName = ...
            //data.....
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
            
            //Make sure call completion()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
}



extension AppDelegate: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if (arguments as! String? == "media") {
            eventSinkMedia = events
        } else {
            return FlutterError.init(code: "NO_SUCH_ARGUMENT", message: "No such argument\(String(describing: arguments))", details: nil);
        }
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSinkMedia = nil
        return nil;
    }
}

extension AppDelegate {
    
    func hasMatchingSchemePrefix(url: URL?) -> Bool {
        guard let url = url, let appDomain = Bundle.main.bundleIdentifier else {
            return false
        }
        
        return url.absoluteString.hasPrefix("\(self.schemePrefix)-\(appDomain)")
    }
    
    public func handleUrl(url: URL?, setInitialData: Bool) -> Bool {
        if let url = url {
            let appDomain = Bundle.main.bundleIdentifier!
            let appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(Bundle.main.bundleIdentifier!)"
            
            let userDefaults = UserDefaults(suiteName: appGroupId)

            if let key = url.host?.components(separatedBy: "=").last,
               let json = userDefaults?.object(forKey: key) as? Foundation.Data {
                let sharedArray = decode(data: json)
                let sharedMediaFiles: [ImportedFile] = sharedArray.compactMap {
                    guard let path = getAbsolutePath(for: $0.path) else {
                        return nil
                    }
                    
                    return ImportedFile.init(
                        path: path,
                        name: $0.name
                    )
                }

                latestMedia = sharedMediaFiles
                if(setInitialData) {
                    initialMedia = latestMedia
                }
                
                self.eventSinkMedia?(toJson(data: latestMedia))
            }
            return true
        }
        latestMedia = nil
        return false
    }
    
    private func getAbsolutePath(for identifier: String) -> String? {
        if (identifier.starts(with: "file://")) {
            return identifier.replacingOccurrences(of: "file://", with: "")
        }
        let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: .none).firstObject
        if(phAsset == nil) {
            return nil
        }
        return getAssetUrl(for: phAsset!)
    }
    
    private func getAssetUrl(for asset: PHAsset)-> (String?) {
        var url: String? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let options2 = PHContentEditingInputRequestOptions()
        options2.isNetworkAccessAllowed = true
        asset.requestContentEditingInput(with: options2){(input, info) in
            url = input?.fullSizeImageURL?.path
            semaphore.signal()
        }
        semaphore.wait()
        return url
    }
    
    private func decode(data: Foundation.Data) -> [ImportedFile] {
        let encodedData = try? JSONDecoder().decode([ImportedFile].self, from: data)
        return encodedData!
    }
    
    private func toJson(data: [ImportedFile]?) -> String? {
        if data == nil {
            return nil
        }
        let encodedData = try? JSONEncoder().encode(data)
        let json = String(data: encodedData!, encoding: .utf8)!
        return json
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
