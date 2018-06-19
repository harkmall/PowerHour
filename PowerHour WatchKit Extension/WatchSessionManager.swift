//
//  WatchSessionManager.swift
//  PowerHour WatchKit Extension
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import WatchConnectivity

protocol ApplicationContextChangedDelegate {
    func didReceiveSong(_ song: Song)
    func didChangePlayingState(_ state: SongState)
    func volumeDidChange(_ volume: Float)
}

class WatchSessionManager: NSObject {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    var applicationContextChangedDelegate: ApplicationContextChangedDelegate?
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func updateApplicationContext(_ applicationContext: [String: Any]) throws {
        do {
            try session.updateApplicationContext(applicationContext)
        } catch let error {
            throw error
        }
    }
    
}

extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {

    }
}
