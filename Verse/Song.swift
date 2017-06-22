//
//  Song.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

//import RealmSwift
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

class Song {

  var id: String!
  var name: String!
  var artist: String!
  var album: String!
  var artwork: Photo!
  var releaseDate: Date!

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

}
