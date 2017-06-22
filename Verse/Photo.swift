//
//  Photo.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import Foundation

class Photo {

  var id: String!
  var url: String!
  var data: Data?

  convenience init(id: String = UUID().uuidString,
                   url: String,
                   data: Data? = nil) {
    self.init()
    self.id = id
    self.url = url
    self.data = data
  }

}
