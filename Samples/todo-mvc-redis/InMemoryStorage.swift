//
//  InMemoryStorage.swift
//  Noze.io
//
//  Created by Helge Heß on 7/24/16.
//  Copyright © 2016 ZeeZide GmbH. All rights reserved.
//

/// A collection store which just stores everything in memory. Data added will
/// be gone when the process is stopped.
///
class InMemoryCollectionStore<T> : CollectionStore {

  // TODO: move to Redis
  var sequence = 1337

  var objects = [ Int : T ]()

  init() {
  }
  
  func nextKey(cb: ( Int ) -> Void) {
    sequence += 1
    cb(sequence)
  }
  
  func getAll(cb: ( [ T ] ) -> Void) {
    cb(Array(objects.values))
  }
  
  func get(id key: Int, cb: ( T? ) -> Void) {
    cb(objects[key])
  }
  
  func delete(id key: Int, cb: () -> Void) {
    objects.removeValue(forKey: key)
    cb()
  }
  
  func update(id key: Int, value v: T, cb: ( T ) -> Void) {
    objects[key] = v // value type!
    cb(v)
  }
  
  func deleteAll(cb: () -> Void) {
    objects.removeAll()
    cb()
  }
}
