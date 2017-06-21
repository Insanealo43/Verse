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
  dynamic var artwork: Photo!
  dynamic var releaseDate: Date!

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
    self.init()
    self.id = String(id)
    self.name = name
    self.artist = artist
    self.album = album
    self.artwork = Photo(url: artworkUrl)
    self.releaseDate = dateFormatter.date(from: releaseDate)!
  }

  override static func primaryKey() -> String? {
    return "id"
  }

}
