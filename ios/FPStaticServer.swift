//
//  FPStaticServer.swift
//  FPStaticServer
//
//  Created by Osiloke Emoekpere on 24/07/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import Rntools

@objc(FPStaticServer)
class FPStaticServer: NSObject {
    // MARK: Properties
    var hlsproxy : RntoolsHLSProxy!
    var webserver: GCDWebServer!
    var www_root = ""
    var keep_alive = true
    var localhost_only = false
    var port: NSNumber?
    var url: String?
    
    // MARK:
    deinit {
        // perform the deinitialization
        if (webserver.isRunning){
            webserver.stop()
        }
    }
    
    override init() {
        webserver = GCDWebServer()
        GCDWebServer.setLogLevel(0)
        hlsproxy = RntoolsNewHLSProxy()
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
        
//        self.keep_alive = keepAlive
        self.localhost_only = localOnly
        if webserver.isRunning != false {            
            print("StaticServer already running at \(self.url ?? "")")
            resolve(self.url)
            return
        }
        webserver.addGETHandler(forBasePath: "/", directoryPath: self.www_root, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        webserver.addHandler(forMethod: "GET", path: "/cache", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
            let fileURL = try? request.query?["file"] as! String
           
            let result = self.hlsproxy.has(fileURL)
            if (result?.ok())!{
                let key = result?.key() as! String
                var contentType = "application/octet-stream"
                if (fileURL?.range(of:".m3u8") != nil){
                    contentType = "application/vnd.apple.mpegurl"
                }
                if (fileURL?.range(of:".ts") != nil){
                    contentType = "video/MP2T"
                }
                
                let filepath = "\(self.www_root)/\(key)"
                
                print("serving", filepath)
                let data = NSData(contentsOfFile: filepath)!
                return GCDWebServerDataResponse(data: data as Data, contentType: contentType)
            }
            print("hasData", result?.data(), "hasError", result?.error())
            return GCDWebServerDataResponse(statusCode: 400)
        }
        var options: [String : Any] = [:]
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
            self.hlsproxy.setup(self.url, cachePath: www_root)
//            self.hlsproxy.clear()
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

