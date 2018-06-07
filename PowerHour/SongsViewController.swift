//
//  SongsViewController.swift
//  PowerHour
//
//  Created by Mark Hall on 2018-06-04.
//  Copyright © 2018 markhall. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songs = SongsDataSource().getSongs()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nowPlayingVC = segue.destination as? NowPlayingViewController,
            let song = sender as? Song {
            nowPlayingVC.song = song
        }
    }
}

extension SongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = songs[indexPath.row]
        performSegue(withIdentifier: "showNowPlayingSegue", sender: selectedSong)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
}

