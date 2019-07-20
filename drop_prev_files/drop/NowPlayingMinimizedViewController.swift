//
//  NowPlayingMinimizedViewController.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-16.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import MediaPlayer

class NowPlayingModel {
    let system = AppleMediaPlayerController.shared
    let nowPlaying = BehaviorRelay<MPMediaItem?>(value: AppleMediaPlayerController.shared.player.nowPlayingItem)
    
    func update() {
        nowPlaying.accept(AppleMediaPlayerController.shared.player.nowPlayingItem)
    }
}

class NowPlayingMinimizedViewController : UIViewController {
    let model       = NowPlayingModel()
    let titleLabel  = UILabel(frame: CGRect(x: 71, y: 10, width: 240, height: 20))
    let artistLabel = UILabel(frame: CGRect(x: 71, y: 30, width: 240, height: 20))
    let artwork     = UIImageView(frame: CGRect(x: 5, y: 5, width: 50.0, height: 50.0))
    let gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 343, height: 60)
        gradient.colors = [UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1).cgColor,UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = 5.0
        
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowRadius = 5
        gradient.shadowOffset = CGSize(width: 0, height: 0)
        gradient.shadowOpacity = 0.2
        
        return gradient
    }()
    
    var scrubbing = false
    
    let disposeBag  = DisposeBag()
    
    override func viewDidLoad() {
        
        model.system.playing.onNext(true)
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        nextSwipe.direction = .right
        self.view.addGestureRecognizer(nextSwipe)
        
        let prevSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        prevSwipe.direction = .left
        self.view.addGestureRecognizer(prevSwipe)
        
        let scrubPan = UIPanGestureRecognizer()
        self.view.addGestureRecognizer(scrubPan)
        scrubPan.require(toFail: nextSwipe)
        scrubPan.require(toFail: prevSwipe)
        
        
        tapGesture.rx.event.bind(onNext: { recognizer in
            
        }).disposed(by: disposeBag)
        
        scrubPan.rx.event.bind(onNext: { recognizer in
            switch recognizer.state {
            case (.began):
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: 55)
                })
            case (.ended):
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = .identity
                })
            default:
                self.scrubbing = true
            }
        }).disposed(by: disposeBag)
        
        titleLabel.font  = UIFont.preferredFont(forTextStyle: .headline)
        artistLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        titleLabel.textColor = .white
        artistLabel.textColor = .white
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        model.nowPlaying.subscribe(onNext : { value in
            self.titleLabel.text  = value?.title
            self.artistLabel.text = value?.artist
            self.artwork.image    = value?.artwork?.image(at: CGSize(width: 50, height: 50))
        }).disposed(by: disposeBag)
        
        
        
        artwork.layer.cornerRadius = 5
        artwork.clipsToBounds = true;
        
        let playButton = UIButton(frame: CGRect(x: 301.6, y: 16, width: 24, height: 28))
        
        if (try! model.system.playing.value()) {
            playButton.setImage(UIImage(named: "pause_white"), for: .normal)
        } else {
            playButton.setImage(UIImage(named: "play_white"), for: .normal)
        }
        
        model.system.playing.subscribe(onNext : { value in
            if (value) {
                playButton.setImage(UIImage(named: "pause_white"), for: .normal)
            } else {
                playButton.setImage(UIImage(named: "play_white"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        
        playButton.rx.tap.bind(onNext: { _ in
            let status = try! self.model.system.playing.value()
            self.model.system.playing.onNext(!status)
            
            UIView.animate(withDuration: 0.5, animations: {
                playButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                playButton.transform = .identity
            })
        }).disposed(by: disposeBag)
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(artistLabel)
        self.view.addSubview(artwork)
        self.view.addSubview(playButton)
    }
    
    func update() {
        model.update()
    }
    
    @objc func swipe( _ sender : UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .left:
            self.model.system.player.prepareToPlay()
            self.model.system.player.pause()
            self.model.system.player.skipToPreviousItem()
            self.model.system.player.play()
            self.model.system.playing.onNext(true)
            self.update()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: 25, y: 0)
            })
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = .identity
            })
        case .right:
            self.model.system.player.pause()
            self.model.system.player.skipToNextItem()
            self.model.system.player.play()
            self.model.system.playing.onNext(true)
            self.update()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: -25, y: 0)
            })
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = .identity
            })
        default:
            return
        }
    }
}
