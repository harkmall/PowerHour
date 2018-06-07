//
//  WatchSessionManager.swift
//  PowerHour WatchKit Extension
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import WatchConnectivity

protocol ReceiveSongDelegate {
    func didReceiveSong(songName: String, songArtist: String)
}

class WatchSessionManager: NSObject {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    var receiveSongDelegate: ReceiveSongDelegate?
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
}

extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let songName = applicationContext["songName"] as? String,
            let songArtist = applicationContext["songArtist"] as? String else {
            return
        }
        receiveSongDelegate?.didReceiveSong(songName: songName, songArtist: songArtist)
    }
}
