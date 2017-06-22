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

  @discardableResult
  func favorite(song: Song) throws {
    try Database.cache.insert(song: song)
  }

  @discardableResult
  func unfavorite(song: Song) throws -> Song {
    let unmanagedSong = Song(value: song)
    try Database.cache.delete(song: song)
    return unmanagedSong
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
      try! favorite(song: song)
      return Database.cache.select(song: song.id)!
    }
  }

}
