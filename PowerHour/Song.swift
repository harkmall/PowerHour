//
//  Song.swift
//  PowerHour
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import Foundation

enum SongState {
    case paused
    case playing
}

struct Song {
    var name: String?
    var artist: String?
    var state: SongState = .paused
    
    init(name: String?, artist: String?, state: SongState = .paused) {
        self.name = name
        self.artist = artist
        self.state = state
    }
}
