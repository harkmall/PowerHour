//
//  SongsDataSource.swift
//  PowerHour
//
//  Created by Mark Hall on 2018-06-06.
//  Copyright © 2018 markhall. All rights reserved.
//

import Foundation

struct SongsDataSource {
    
    private var songsArray = [Song]()
    
    init() {
        songsArray.append(Song(name: "When the Levee Breaks", artist: "Led Zepplin"))
        songsArray.append(Song(name: "For What It's Worth", artist: "Buffalo Springfield"))
        songsArray.append(Song(name: "Face to Face", artist: "Daft Punk"))
        songsArray.append(Song(name: "The Chain", artist: "Fleetwood Mac"))
    }
    
    func getSongs() -> [Song] {
        return songsArray
    }
    
}
