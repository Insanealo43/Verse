//
//  SongLabel.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/20/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SongLabel: UILabel {

  func setName(for song: Song) {
    text = song.name
  }

  func setArtist(for song: Song) {
    text = song.artist
  }

  func setReleaseYear(for song: Song) {
    text = String(
      Calendar.current.component(
        .year,
        from: song.releaseDate
      )
    )
  }

}
