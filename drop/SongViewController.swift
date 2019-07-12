//
//  ViewController.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-05.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources
import RxCocoa
import MediaPlayer

class SongViewController: UIViewController {
    
    let viewModel = SongViewModel()
    let system = AppleMediaPlayerController.shared
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let update = PublishSubject<MPMediaItem>()
    let queue  = LinkedList<Song>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_leftMargin).offset(-16)
            make.right.equalTo(self.view.snp_rightMargin).offset(16)
            make.top.equalTo(self.view.snp_topMargin)
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        
        collectionView.register(SongCell.self, forCellWithReuseIdentifier: "SongCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,Song>>(configureCell: { (dataSource, collectionView, indexPath, song) -> UICollectionViewCell in
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCell
            self.viewModel.config(cell: &cell, data: song)
            return cell
        })
        
        viewModel.library.asObservable().map { (library) -> [SectionModel<String,Song>] in
            return [SectionModel(model: "", items: library)]
        }.bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
}

extension SongViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let song : MPMediaItem = viewModel.retrieveSong(index: indexPath.row)
        system.player.setQueue(with: MPMediaItemCollection(items: [song]))
        system.playing.onNext(true)
        update.onNext(song)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let song = self.viewModel.retrieveSong(index: indexPath.row)
        let nowPlaying = (self.system.player.nowPlayingItem)!
        
        if (song == nowPlaying) {
            cell.isSelected = true
        }
        
        let queueGestureRecognizer = SongSwipe(target: self, action: #selector(swipe), index: indexPath.row)
        queueGestureRecognizer.direction = .left
        cell.addGestureRecognizer(queueGestureRecognizer)
        
        let stackGestureRecognizer = SongSwipe(target: self, action: #selector(swipe), index: indexPath.row)
        stackGestureRecognizer.direction = .right
        cell.addGestureRecognizer(stackGestureRecognizer)
    }
    
    @objc func swipe( _ sender : SongSwipe) {
        
        let cell = sender.view as! SongCell
        
        switch sender.direction {
        case .left:
            let last = self.viewModel.retrieveSong(index: sender.songRow)
            let predicate = MPMediaPropertyPredicate(value: last.persistentID, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            self.system.player.append(MPMusicPlayerMediaItemQueueDescriptor(query: query))
            UIView.animate(withDuration: 0.5, animations: {
                cell.transform = CGAffineTransform(translationX: 25, y: 0)
            })
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
            })
        case .right:
            let next = self.viewModel.retrieveSong(index: sender.songRow)
            let predicate = MPMediaPropertyPredicate(value: next.persistentID, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            self.system.player.prepend(MPMusicPlayerMediaItemQueueDescriptor(query: query))
            UIView.animate(withDuration: 0.5, animations: {
                cell.transform = CGAffineTransform(translationX: -25, y: 0)
            })
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
            })
        default:
            return
        }
    }
}

extension SongViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 343, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

class SongSwipe : UISwipeGestureRecognizer {
    let songRow : Int
    
    init(target: Any?, action: Selector?, index: Int) {
        self.songRow = index
        super.init(target: target, action: action)
    }
}

