//
//  SongModel.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-06.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift

enum SongLibraryError: Error {
    case empty
    case load
}

class SongModel {
    private let appleSongLibrary: Result<[MPMediaItem],SongLibraryError> = { () -> Result<[MPMediaItem],SongLibraryError> in
        guard let songs = MPMediaQuery.songs().items else { return .failure(.load) }
        if (songs == []) { return .failure(.load) }
        return .success(songs)
    }()
    
    func retrieveAppleLibrary() throws -> [MPMediaItem] {
        switch appleSongLibrary {
        case .success(let library):
            return library
        case .failure(let error):
            throw error
        }
    }
    
    func retrieveSongData(index i : Int) throws -> MPMediaItem {
        switch appleSongLibrary {
        case .success(let library):
            return library[i]
        case .failure(let error):
            throw error
        }
    }
}
