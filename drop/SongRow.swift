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
            Image(uiImage: song.artwork!).resizable().frame(width: 50, height: 50, alignment: .leading)
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
        
        return List (viewModel.library) { song in
            Button(action: {}) {
            SongRow(song: song)
            }
        }
    .position(x: 195, y: 0)
        
    }
}

#if DEBUG
struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongContentView()
    }
}
#endif
