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
    @IBOutlet weak var volumeSlider: UISlider!
    
    let maxVolume: Float = 5
    var currentVolumeLevel: Float = 1 {
        didSet {
            do {
                try WatchSessionManager.sharedManager.updateApplicationContext(["volume": currentVolumeLevel])
            } catch let error {
                print(error)
            }
        }
    }
    
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
        currentVolumeLevel = sender.value
    }

}

extension NowPlayingViewController: ApplicationContextChangedDelegate {

    func didChangePlayingState(_ state: SongState) {
        DispatchQueue.main.async {
            self.song.state = state
            self.playPauseUpdateSongState(state: self.song.state, sendUpdate: false)
        }
    }
    
    func volumeDidChange(_ volume: Float) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.volumeSlider.setValue(volume, animated: true)
            })
        }
    }
    
}
