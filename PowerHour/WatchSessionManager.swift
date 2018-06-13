//
//  WatchSessionManager.swift
//  PowerHour
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import WatchConnectivity

protocol ApplicationContextChangedDelegate {
    func didChangePlayingState(_ state: SongState)
    func volumeDidChange(_ volume: Float)
}

class WatchSessionManager: NSObject {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    var applicationContextChangedDelegate: ApplicationContextChangedDelegate?
    
    private var validSession: WCSession? {
        if let session = session, session.isPaired, session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func updateApplicationContext(_ applicationContext: [String: Any]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
}

extension WatchSessionManager: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let stateString = applicationContext["state"] as? String, let songState = SongState(rawValue: stateString) {
            applicationContextChangedDelegate?.didChangePlayingState(songState)
        }
        else if let volume = applicationContext["volume"] as? Float {
            applicationContextChangedDelegate?.volumeDidChange(volume)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    
    
}

