//
//  MediaPlayerController.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-06.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MediaPlayer

class AppleMediaPlayerController {
    static let shared = AppleMediaPlayerController()
    let player = MPMusicPlayerApplicationController.systemMusicPlayer
    let playing = BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()
    
    private init() {
        playing.subscribe(onNext : { state in
            switch (state) {
            case (true):
                self.player.play()
            case (false):
                self.player.pause()
            }
        }).disposed(by: disposeBag)
    }
}

