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
        
    }
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        switch song.state {
        case .playing:
            song.state = .paused
            playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        case .paused:
            song.state = .playing
            playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {

    }

}
