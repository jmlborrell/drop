//
//  SongViewModel.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-07.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import MediaPlayer

enum MediaType {
    case song
    case album
}

enum Service {
    case apple
    case spotify
}

protocol DropMedia {
    var title  : String  { get }
    var artist : String  { get }
    var artwork: UIImage { get }
    var service: Service { get }
    
    func play()
}

struct Song : Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let artwork: UIImage?
    
    init(named title: String, by artist: String, artwork art: UIImage?) {
        self.title = title
        self.artist = artist
        self.artwork = art
    }
}

class SongViewModel {
    
    private let model = SongModel()
    private var songStreamMap : Dictionary<UUID,MPMediaItem> = Dictionary<UUID,MPMediaItem>()
    private var library: [Song]
    
    init() {
        
        let lib: [MPMediaItem]
        var streamMap : Dictionary<UUID,MPMediaItem> = Dictionary<UUID,MPMediaItem>()
        
        
        do { try lib = model.retrieveAppleLibrary() } catch { lib = [] }
        
        library =  lib.map({ (data) -> Song in
            let song = Song(named: data.title ?? "No Title", by: data.artist ?? "No Artist", artwork: data.artwork?.image(at: CGSize(width: 150, height: 150)))
            streamMap[song.id] = data
            return song
        })
        
        songStreamMap = streamMap
    }
    
    func songAtIndex(index i: Int) -> Song {
        return library[i]
    }
    
    func requestLibraryLength() -> Int {
        return library.count
    }
    
    func retrieveSong(index i: Int) -> MPMediaItem {
        guard let item = songStreamMap[library[i].id] else {
            return .init()
        }
        return item
    }
}
