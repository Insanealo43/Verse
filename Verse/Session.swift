//
//  Session.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import Foundation
import PromiseKit

class Session {

  static let current = Session()

  func getSongs(for query: String) -> Promise<[Song]> {
    return Service.shared
      .request(
        url: Service.URLs.itunes.rawValue,
        method: .post,
        parameters: [
          "term": query.encoded()
        ]
      )
      .then { json in
        let results = json["results"].array ?? []
        return Promise(value: results.flatMap { Song($0) })
      }
  }

  func getLyrics(for song: Song) -> Promise<String> {
    let query = "?func=getSong&fmt=json&artist=\(song.artist.encoded())&song=\(song.name.encoded())"
    let url = "\(Service.URLs.lyrics.rawValue)" + query
    return Service.shared
      .requestPropertyList(
        url: url,
        method: .get
      )
      .then { json in
        return Promise(value: "")
    }
  }

}

private extension String {

  func encoded() -> String {
    return self
      .components(separatedBy: .whitespaces)
      .filter { !$0.isEmpty }
      .joined(separator: "+")
      .replacingOccurrences(of: "feat.", with: "")
      .replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
      .replacingOccurrences(of: "&", with: "")
  }

}
