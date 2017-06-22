//
//  Session+Song.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import RealmSwift

extension Session {

  var favoriteSongs: Results<Song> {
    return Database.cache.favorties
  }

  func favorite(song: Song) throws {
    try Database.cache.insert(song: song)
  }

  func unfavorite(song: Song) throws -> Song {
    let validSong = Song(
      id: song.id,
      name: song.name,
      artist: song.artist,
      album: song.album,
      releaseDate: song.releaseDate,
      artwork: song.artwork
    )
    try Database.cache.delete(song: song)
    return validSong
  }

  func isFavorite(song id: String) -> Bool {
    return Database.cache.select(song: id) != nil
  }

  func toggleFavorite(song: Song) -> Song {
    if isFavorite(song: song.id) {
      let song = Database.cache.select(song: song.id)!
      return try! unfavorite(song: song)
    }
    else {
      try? favorite(song: song)
      return Database.cache.select(song: song.id)!
    }
  }

}
