//
//  SearchViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    User.current.getSongs(for: "tom  waits")
    .then { songs in
      print("Songs: \(songs)")
    }
    .catch { error in
      print("Error: \(error)")
    } 
  }

}

extension SearchViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    
  }

}
