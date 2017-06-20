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
    let url = Service.URLs.itunes.rawValue
    let term = query.components(separatedBy: .whitespaces)
      .filter { !$0.isEmpty }
      .joined(separator: "+")
    let params = ["term": term]
    return Service.shared
      .request(url: url, method: .post, parameters: params)
      .then { json in
        guard let results = json["results"].array else {
          return Promise(value: [])
        }
        return Promise(value: results.flatMap { Song($0) })
      }
  }

}
