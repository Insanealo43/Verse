//
//  Session.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import PromiseKit

class Session {

  enum Error: Swift.Error {

    case objectSerialization(error: Swift.Error)

  }

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

  func getLyrics(for song: Song) -> Promise<URL> {
    let name = song.name
      .components(separatedBy: "(").first!
      .components(separatedBy: "[").first!
    let params = [
      "func": "getSong",
      "fmt": "json",
      "artist": song.artist.encoded(),
      "song": name.encoded()
    ]
    let url = Service.URLs.lyrics.rawValue + params.queryString()
    return Service.shared
      .request(
        url: url,
        method: .get
      )
      .then { json in
        guard
          let jsString = json.array?.first?.string,
          !jsString.contains("Not found"),
          let jsUrl = jsString.components(separatedBy: "\'url\':").last
          else {
            return Promise(error:
              Session.Error.objectSerialization(
                error: NSError(domain: #function)
              )
            )
        }
        let url = jsUrl.replacingOccurrences(of: "\\", with: "")
          .replacingOccurrences(of: "\'", with: "")
          .replacingOccurrences(of: "\n", with: "")
          .replacingOccurrences(of: "}", with: "")
        return Promise(value: URL(string: url)!)
    }
  }

}

private extension String {

  func encoded() -> String {
    return components(separatedBy: .whitespaces)
      .filter { !$0.isEmpty }
      .joined(separator: "+")
      .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
  }

}

private extension Dictionary {

  func queryString() -> String {
    return "?" + map { "\($0.key)=\($0.value)" }
      .joined(separator: "&")
  }

}

private extension NSError {

  convenience init(domain: String) {
    self.init(domain: domain, code: -999, userInfo: nil)
  }

}
