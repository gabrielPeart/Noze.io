// Noze.io: miniirc

// MARK: - String Helpers

#if swift(>=3.0) // #swift3-fd
#else

extension CollectionType where Generator.Element : Equatable {
  
  func index(of v: Self.Generator.Element, from: Self.Index) -> Index? {
    var idx = from
    
    while idx != endIndex {
      if self[idx] == v {
        return idx
      }
      idx = idx.successor()
    }
    
    return nil
  }

}
  
extension String {
  
  func split(c: Character) -> [ String ] {
    return self.characters.split(c).map { String($0) }
  }
  
}

#endif // Swift 2.2
