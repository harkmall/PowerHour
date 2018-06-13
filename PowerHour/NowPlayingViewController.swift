//
//  NowPlayingViewController.swift
//  PowerHour
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    var song: Song!

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songNameLabel.text = song.name
        artistNameLabel.text = song.artist
        
        do {
            try WatchSessionManager.sharedManager.updateApplicationContext(["song": song.serialized()])
        } catch {
            print("Looks like your song got stuck on the way! Please send again!")
        }
        WatchSessionManager.sharedManager.applicationContextChangedDelegate = self
    }
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        song.state = song.state == .playing ? .paused : .playing
        playPauseUpdateSongState(state: song.state, sendUpdate: true)
    }
    
    func playPauseUpdateSongState(state: SongState, sendUpdate: Bool) {
        switch state {
        case .playing:
            playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        case .paused:
            playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        }
        if sendUpdate {
            do {
                try WatchSessionManager.sharedManager.updateApplicationContext(["state": state.rawValue])
            } catch let error {
                print(error)
            }
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {

    }

}

extension NowPlayingViewController: ApplicationContextChangedDelegate {

    func didChangePlayingState(_ state: SongState) {
        song.state = state
        playPauseUpdateSongState(state: song.state, sendUpdate: false)
    }
    
}
