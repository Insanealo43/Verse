//
//  SongTableViewCell.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

  var song: Song! {
    willSet {
      albumImageView.photo = newValue.artwork
      trackLabel.setName(for: newValue)
      artistLabel.setArtist(for: newValue)
      infoLabel.setAlbumInfo(for: newValue)
    }
  }

  @IBOutlet
  private weak var albumImageView: PhotoImageView!

  @IBOutlet
  private weak var trackLabel: SongLabel!

  @IBOutlet
  private weak var artistLabel: SongLabel!

  @IBOutlet
  private weak var infoLabel: SongLabel!

}
