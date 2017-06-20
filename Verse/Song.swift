//
//  Song.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Song: Object {

  dynamic var id: String!

  convenience init?(_ json: JSON) {
    guard
      json["kind"].string == "song",
      let id = json["trackId"].uInt
      else {
      return nil
    }
    self.init()
    self.id = String(id)
  }

  override static func primaryKey() -> String? {
    return "id"
  }

}
