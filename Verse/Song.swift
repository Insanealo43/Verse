//
//  Song.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import RealmSwift
import SwiftyJSON

@available(iOS 10.0, *)
var dateFormatter: ISO8601DateFormatter = {
  let formatter = ISO8601DateFormatter()
  formatter.formatOptions = [
    .withInternetDateTime,
    .withTimeZone,
    .withDashSeparatorInDate,
    .withColonSeparatorInTime
  ]
  return formatter
}()

class Song: Object {

  dynamic var id: String!
  dynamic var name: String!
  dynamic var artist: String!
  dynamic var album: String!
  dynamic var releaseDate: Date!
  dynamic var artwork: Photo!

  convenience init?(_ json: JSON) {
    guard
      json["kind"].string == "song",
      let id = json["trackId"].uInt,
      let name = json["trackName"].string,
      let artist = json["artistName"].string,
      let album = json["collectionName"].string,
      let artworkUrl = json["artworkUrl100"].string,
      let releaseDate = json["releaseDate"].string
      else {
      return nil
    }
    self.init(
      id: String(id),
      name: name,
      artist: artist,
      album: album,
      releaseDate: dateFormatter.date(from: releaseDate)!,
      artwork: Photo(url: artworkUrl)
    )
  }

  convenience init(id: String = UUID().uuidString,
                   name: String,
                   artist: String,
                   album: String,
                   releaseDate: Date,
                   artwork photo: Photo) {
    self.init()
    self.id = id
    self.name = name
    self.artist = artist
    self.album = album
    self.releaseDate = releaseDate
    self.artwork = photo
  }

  override static func primaryKey() -> String? {
    return "id"
  }

}
