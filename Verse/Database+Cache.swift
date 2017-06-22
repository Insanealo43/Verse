//
//  Database+Cache.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import RealmSwift

extension Database {

  class Cache: Database {

    static let DidInsertSongNotificationName = NSNotification.Name("DidInsertSong")

    static let DidDeleteSongNotificationName = NSNotification.Name("DidDeleteSong")

    private(set) lazy var favorties: Results<Song> = self.results()

    func select(song id: String) -> Song? {
      return favorties.filter("id == %@", id).last
    }

    func insert(song: Song) throws {
      return try Database.cache.insert(
        objects: [song],
        notificationName: Cache.DidInsertSongNotificationName
      )
    }

    func delete(song: Song) throws {
      return try Database.cache.delete(
        objects: [song],
        notificationName: Cache.DidDeleteSongNotificationName
      )
    }

  }

  static let cache: Cache = {
    var database: Database.Cache!
    do {
      let configuration = Realm.Configuration(
        fileURL: try Cache.url(),
        inMemoryIdentifier: nil,
        syncConfiguration: nil,
        encryptionKey: nil,
        readOnly: false,
        schemaVersion: 0,
        migrationBlock: nil,
        deleteRealmIfMigrationNeeded: true,
        objectTypes: nil
      )
      if let cache = try? Cache(configuration: configuration) {
        database = cache
      }
      else {
        database = try Cache(configuration: configuration)
      }
    }
    catch {
      debugPrint(error)
    }
    return database
  }()

}
