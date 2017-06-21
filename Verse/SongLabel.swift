//
//  SongLabel.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/20/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SongLabel: UILabel {

  static func releaseYear(for song: Song) -> String {
    return String(
      Calendar.current.component(.year, from: song.releaseDate)
    )
  }

  func setName(for song: Song) {
    text = song.name
  }

  func setArtist(for song: Song) {
    text = song.artist
  }

  func setAlbumInfo(for song: Song) {
    text = "\(song.album!), \(SongLabel.releaseYear(for: song))"
  }

}
