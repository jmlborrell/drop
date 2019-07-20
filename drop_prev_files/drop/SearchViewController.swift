//
//  SearchViewController.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-15.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MediaPlayer

class SearchViewController: UIViewController {
    
    let viewModel = SongViewModel()
    let player = AppleMediaPlayerController.shared.player
    let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let disposeBag = DisposeBag()
    let searchBar = UITextField(frame: CGRect(x: 60, y: 100, width: 260, height: 30))
    let searchHeader : UILabel = UILabel(frame: CGRect(x: 137, y: 52.2, width: 150, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileIcon : UIButton = UIButton(frame: CGRect(x: 22.8, y: 58.8, width: 30, height: 30))
        profileIcon.setImage(UIImage(named: "profile.pdf"), for: .normal)
        self.view.addSubview(profileIcon)
        let searchIcon : UIButton = UIButton(frame: CGRect(x: 323.9, y: 58.8, width: 30, height: 30))
        searchIcon.setImage(UIImage(named: "search.pdf"), for: .normal)
        self.view.addSubview(searchIcon)
        
        searchBar.font = UIFont(name: "Avenir", size: 16)
        searchBar.attributedPlaceholder = NSAttributedString(string: "search songs, albums, lyrics...")
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 5
        
        
        let searchResults = searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Song]> in
                if query.isEmpty {
                    return .just([])
                }
                return self.viewModel.searchLibrary(for: query)
                    .catchErrorJustReturn([])
            }
            .observeOn(MainScheduler.instance)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        

        self.view.addSubview(searchCollectionView)
        self.view.addSubview(searchBar)
        
        searchCollectionView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_leftMargin).offset(11.3)
            make.right.equalTo(self.view.snp_rightMargin).offset(-11.3)
            make.top.equalTo(self.view.snp_topMargin).offset(65.0)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-75.0)
        }
        
        searchCollectionView.isHidden = true
        searchCollectionView.register(SongCell.self, forCellWithReuseIdentifier: "SongCell")
        searchCollectionView.backgroundColor = .white
        searchCollectionView.delegate = self
        
        viewModel.library.asObservable().bind(to: searchCollectionView.rx.items(cellIdentifier: "SongCell")) {
            (index, song: Song, cell) in
            var songCell = cell as! SongCell
            self.viewModel.config(cell: &songCell, data: song)
            }
            .disposed(by: disposeBag)
        
        searchHeader.text = "Search"
        searchHeader.font = UIFont(name: "Avenir-Black", size: 36)
        self.view.addSubview(searchHeader)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SongCell
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            cell.transform = .identity
        }
        
        player.setQueue(with: MPMediaItemCollection(items: [viewModel.retrieveSong(index: indexPath.row)]))
        player.prepareToPlay()
        player.play()
    }
}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 300, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 3.0, left: 0.0, bottom: 3.0, right: 0.0)
    }
}
