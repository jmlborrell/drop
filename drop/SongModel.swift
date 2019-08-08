//
//  SongModel.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-06.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import MediaPlayer

enum SongLibraryError: Error {
    case empty
    case load
}


class SongModel {
    private var appleSongLibrary: Result<[MPMediaItem],SongLibraryError> = .failure(.load)
    
    func request() {
        var songs : Result<[MPMediaItem],SongLibraryError> = .failure(.load)
        
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized:
            guard let lib = MPMediaQuery.songs().items else { songs = .failure(.load); break }
            if (lib == []) { songs = .failure(.load); break }
            songs = .success(lib)
            
        case .notDetermined:
            
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        guard let lib = MPMediaQuery.songs().items else { songs = .failure(.load); return }
                        if (lib == []) { songs = .failure(.load) }
                        songs = .success(lib)
                    }
                }
            }
            
        case .denied: // The user has previously denied access.
            songs = .failure(.load)
            
        case .restricted: // The user can't grant access due to restrictions.
            songs = .failure(.load)
        @unknown default:
            songs = .failure(.load)
        }
        
        appleSongLibrary = songs
    }
    
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
