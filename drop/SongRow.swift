//
//  SongRow.swift
//  drop
//
//  Created by Jose Borrell on 2019-07-19.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import SwiftUI

struct SongRow: View {
    
    var song : Song
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                Text(self.song.title)
                    .fontWeight(.bold)
                Text(self.song.artist)
                    .foregroundColor(Color.gray)
                }
            }
    }
}

struct SongContentView: View {
    
    let viewModel = SongViewModel()
    
    var body: some View {
        List {
            ForEach(0...5, id: \.id) { index in
                SongRow(song: self.viewModel.songAtIndex(index: index))
            }
        }
    }
}

#if DEBUG
struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongContentView()
    }
}
#endif
