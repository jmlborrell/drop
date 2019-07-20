//
//  SongContentView.swift
//  drop
//
//  Created by Jose Borrell on 2019-07-19.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import SwiftUI

struct HeaderButtonStyle: ViewModifier {
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 255/255, green: 45/255, blue: 85/255),     Color(.sRGB, red: 175/255, green: 82/255, blue: 222/255)]), startPoint: .init(x: 0.0, y: 0.0), endPoint: .init(x:0.6, y:0.0))
    
    func body(content: Content) -> some View {
         content
         .frame(height: 15)
         .foregroundColor(Color.white)
         .padding()
         .background(gradient)
         .cornerRadius(10)
    }
}

enum LibraryCategories {
    case Recent
    case Songs
    case Albums
    case Playlists
}

extension View {
    func headerButtonStyle() -> some View {
        Modified(content: self, modifier: HeaderButtonStyle())
    }
}

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "memories")
                                Text("Recent")
                                    .fontWeight(.heavy)
                            }
                            .headerButtonStyle()
                        }
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "music.note")
                                Text("Songs")
                                    .fontWeight(.heavy)
                            }
                            .headerButtonStyle()
                        }
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "square.stack.3d.down.right.fill")
                                Text("Albums")
                                    .fontWeight(.heavy)
                            }
                            .headerButtonStyle()
                        }
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "music.note.list")
                                Text("Playlists")
                                    .fontWeight(.heavy)
                            }
                            .headerButtonStyle()
                        }
                    }
                    .padding()
                    .navigationBarTitle(Text("Library"))
                    
                }
                .position(x: 185, y: 40)
                
                SongContentView()
            }
        }
    }
}

#if DEBUG
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

