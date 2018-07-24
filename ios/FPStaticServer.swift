//
//  FPStaticServer.swift
//  FPStaticServer
//
//  Created by Osiloke Emoekpere on 24/07/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@objc(FPStaticServer)
class FPStaticServer: NSObject {
    // MARK: Properties
    var webserver: GCDWebServer!
    var www_root = ""
    var keep_alive = false
    var localhost_only = false
    var port: NSNumber?
    var url: String?
    
    // MARK:
    deinit {
        // perform the deinitialization
//        NotificationCenter.default.removeObserver(webserver)
        if (webserver.isRunning){
            webserver.stop()
        }
    }
    
    override init() {
       webserver = GCDWebServer()
    }
    
    @objc var bridge: RCTBridge?
    @objc func methodQueue() ->  DispatchQueue {
        return DispatchQueue(label: "com.futurepress.staticserver")
    }
    // MARK: Start/Stop
    @objc(start:optroot:localOnly:keepAlive:resolver:rejecter:)
    func start(port: String, optroot: String, localOnly: Bool, keepAlive: Bool, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        var root: String
        if (optroot == "DocumentDir") {
            root = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
        } else if (optroot == "BundleDir") {
            root = "\(Bundle.main.bundlePath)"
        } else if optroot.hasPrefix("/") {
            root = optroot
        } else {
            root = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(optroot)"
        }
        if root != "" && root.count > 0 {
            self.www_root = root
        }
        
        if !port.isEmpty  {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            self.port =  f.number(from: port) 
        } else {
            self.port = -1
        }
        self.keep_alive = keepAlive
        self.localhost_only = localOnly
        if webserver.isRunning != false {            
            print("StaticServer already running at \(self.url ?? "")")
            resolve(self.url)
            return
        }
        webserver.addGETHandler(forBasePath: "/", directoryPath: self.www_root, indexFilename: "index.html", cacheAge: 3600, allowRangeRequests: true)
        
        
        var options: [AnyHashable : Any] = [:]
        print("Started StaticServer on port \(port)")
        if !(self.port == -1) {
            options[GCDWebServerOption_Port] = NSNumber(value: Int64(port)!)
        } else {
            options[GCDWebServerOption_Port] = 8080
        }
        if self.localhost_only == true {
            options[GCDWebServerOption_BindToLocalhost] = true
        }
        if keep_alive == true {
            options[GCDWebServerOption_AutomaticallySuspendInBackground] = false
            options[GCDWebServerOption_ConnectedStateCoalescingInterval] = 2.0
        }
        try? webserver.start(options: options)
        let listenPort = webserver.port
        self.port = listenPort as NSNumber
        if webserver.serverURL == nil {
            reject("server_error", "StaticServer could not start", NSError(domain:"", code: 401, userInfo:[ NSLocalizedDescriptionKey: "Server URL is nil"]))
        } else {
            self.url = String((webserver.serverURL?.absoluteString.dropLast())!)
            NSLog("Started StaticServer at URL \(String(describing: self.url))")
            resolve(self.url)
        }
    }
    @objc(oresolver:rejecter:)
    func origin(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        if(webserver.isRunning == true) {
            resolve(self.url)
        }else{
            resolve(NSString())
        }
        
    }
    @objc(stop)
    func stop() {
        if(webserver.isRunning == true) {
            webserver.stop()
            print("StaticServer stopped")
        }
        
    }
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }

    
}

