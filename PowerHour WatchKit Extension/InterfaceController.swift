//
//  InterfaceController.swift
//  PowerHour WatchKit Extension
//
//  Created by Mark Hall on 2018-06-04.
//  Copyright © 2018 markhall. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var playPauseButton: WKInterfaceButton!
    @IBOutlet var volumeSlider: WKInterfaceSlider!
    @IBOutlet var artistLabel: WKInterfaceLabel!
    @IBOutlet var songLabel: WKInterfaceLabel!
    
    var songState: SongState = .paused
    var currentVolumeLevel: Float = 1.0
    let numberOfSteps = 3
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        crownSequencer.delegate = self
        volumeSlider.setValue(currentVolumeLevel)
        WatchSessionManager.sharedManager.applicationContextChangedDelegate = self
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
    
    @IBAction func playPauseButtonPressed() {
        songState = songState == .playing ? .paused : .playing
        updateSongState(state: songState, sendUpdate: true)
    }
    
    @IBAction func sliderValueChanged(_ value: Float) {
        currentVolumeLevel = value
    }
    
    func updateSongState(state: SongState, sendUpdate: Bool) {
        switch state {
        case .paused:
            playPauseButton.setBackgroundImage(UIImage(named: "Play"))
        case .playing:
            playPauseButton.setBackgroundImage(UIImage(named: "Pause"))
        }
        if sendUpdate {
            do {
                try WatchSessionManager.sharedManager.updateApplicationContext(["state": state.rawValue])
            } catch let error {
                print(error)
            }
        }
    }

}

extension InterfaceController: ApplicationContextChangedDelegate {
    func didReceiveSong(_ song: Song) {
        songLabel.setText(song.name)
        artistLabel.setText(song.artist)
    }
    
    func didChangePlayingState(_ state: SongState) {
        songState = state
        updateSongState(state: songState, sendUpdate: false)
    }
}

extension InterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let predictedVolumeLevel = currentVolumeLevel + Float(rotationalDelta) * 10
        guard predictedVolumeLevel > 0.0 && predictedVolumeLevel <= Float(numberOfSteps) else {
            return
        }
        currentVolumeLevel = predictedVolumeLevel
        volumeSlider.setValue(currentVolumeLevel)
    }
}
