//
//  Database.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import RealmSwift

class Database {

  static func url(bundled: Bool = false) throws -> URL {
    return bundled
      ? Bundle.main.url(forResource: "\(self)", withExtension: "realm")!
      : try FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("\(self).realm")
  }

  let realm: Realm

  init(configuration: Realm.Configuration) throws {
    realm = try Realm(configuration: configuration)
  }

  func results<T: Object>() -> Results<T> {
    return realm.objects(T.self)
  }

  func insert<T: Sequence>(objects: T,
              notificationName: NSNotification.Name) throws where T.Iterator.Element: Object {
    try autoreleasepool {
      realm.beginWrite()
      realm.add(objects, update: false)
      try realm.commitWrite()
      NotificationCenter.default.post(name: notificationName, object: nil)
    }
  }

  func delete<T: Sequence>(objects: T,
              notificationName: NSNotification.Name) throws where T.Iterator.Element: Object {
    try autoreleasepool {
      realm.beginWrite()
      realm.delete(objects)
      try realm.commitWrite()
      NotificationCenter.default.post(name: notificationName, object: nil)
    }
  }

}
