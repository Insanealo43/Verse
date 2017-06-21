//
//  User.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import Foundation
import PromiseKit

class User {

  static let current = User()

  func getSongs(for query: String) -> Promise<[Song]> {
    let term = query
      .components(separatedBy: .whitespaces)
      .filter { !$0.isEmpty }
      .joined(separator: "+")
    return Service.shared
      .request(
        url: Service.URLs.itunes.rawValue,
        method: .post,
        parameters: [
          "term": term
        ]
      )
      .then { json in
        let results = json["results"].array ?? []
        return Promise(value: results.flatMap { Song($0) })
      }
  }

}
