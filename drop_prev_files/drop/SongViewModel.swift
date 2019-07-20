//
//  SongViewModel.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-07.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import RxSwift
import RxDataSources
import RxCocoa

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

struct Layout {
    var image: UIView
    var header1 : UIView
    var header2 : UIView
    var mediaType : MediaType
    
    init(image: UIView, header1: UIView, header2: UIView, media: MediaType) {
        self.image = image
        self.header1 = header1
        self.header2 = header2
        self.mediaType = media
    }
    
    mutating func layout(in rect: CGRect) {
        switch mediaType {
        case .song:
            image.frame   = CGRect(x: 5.0, y: 5.0, width: 50.0, height: 50.0)
            header1.frame = CGRect(x: 70, y: 10, width: 250, height: 22)
            header2.frame = CGRect(x: 70, y: 29.7, width: 250, height: 20)
        default:
            return
        }
    }
}

struct Song : Hashable {
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
    var songStreamMap : Dictionary<Song,MPMediaItem> = Dictionary<Song,MPMediaItem>()
    var library: BehaviorRelay<[Song]>
    
    init() {
        
        let lib: [MPMediaItem]
        var streamMap : Dictionary<Song,MPMediaItem> = Dictionary<Song,MPMediaItem>()
        
        
        do { try lib = model.retrieveAppleLibrary() } catch { lib = [] }
        
        library = BehaviorRelay<[Song]>(value: lib.map({ (data) -> Song in
            let song = Song(named: data.title ?? "No Title", by: data.artist ?? "No Artist", artwork: data.artwork?.image(at: CGSize(width: 150, height: 150)))
            streamMap[song] = data
            return song
        }))
        
        songStreamMap = streamMap
    }
    
    func config(cell: inout SongCell, data: Song) {
        cell.titleLabel.text = data.title
        cell.artistLabel.text = data.artist
        cell.artwork.image = data.artwork
    }
    
    func songAtIndex(index i: Int) -> Song {
        return library.value[i]
    }
    
    func requestLibraryLength() -> Int {
        return library.value.count
    }
    
    func retrieveSong(index i: Int) -> MPMediaItem {
        guard let item = songStreamMap[library.value[i]] else {
            return .init()
        }
        return item
    }
    
    func searchLibrary(for string: String) -> Observable<[Song]> {
        var results : [Song] = []
        let regex = try? NSRegularExpression(pattern: string, options: .caseInsensitive)
        for song : Song in library.value {
            let title = song.title
            let matches = regex?.matches(in: title, options: [], range: NSRange(location: 0, length: title.count))
            if (matches?.count ?? 0 > 0) {
                results.append(song)
            }
        }
        return BehaviorRelay<[Song]>(value: results).asObservable()
    }
}

class SongCell : UICollectionViewCell {
    
    weak var titleLabel  : UILabel!
    weak var artistLabel : UILabel!
    weak var artwork     : UIImageView!
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
    let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                titleLabel.textColor = .white
                artistLabel.textColor = .white
                self.layer.insertSublayer(gradient, at: 0)
            } else {
                titleLabel.textColor = .black
                artistLabel.textColor = .black
                gradient.removeFromSuperlayer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup title label
        let titleLabel   = UILabel(frame: CGRect(x: 70, y: 10, width: 250, height: 22))
        titleLabel.font  = UIFont.preferredFont(forTextStyle: .headline)
        
        // Setup artist label
        let artistLabel  = UILabel(frame: CGRect(x: 70, y: 29.7, width: 250, height: 20))
        artistLabel.font  = UIFont.preferredFont(forTextStyle: .subheadline)
        
        // Setup artwork background image
        let artwork      = UIImageView(frame: CGRect(x: 5.0, y: 5.0, width: 50.0, height: 50.0))
        artwork.layer.cornerRadius = 5
        artwork.clipsToBounds = true;
        
        // Setup white bar view
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(artistLabel)
        self.contentView.addSubview(artwork)
        
        self.titleLabel  = titleLabel
        self.artistLabel = artistLabel
        self.artwork     = artwork
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.textColor = .black
        artistLabel.textColor = .black
        gradient.removeFromSuperlayer()
    }
}
