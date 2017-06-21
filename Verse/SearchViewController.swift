//
//  SearchViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  fileprivate var songs = [Song]() {
    didSet {
      tableView.reloadData()
    }
  }

  @IBOutlet
  private weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(
      UINib(nibName: "SongResultsTableHeaderView", bundle: nil),
      forHeaderFooterViewReuseIdentifier: "SongsHeader"
    )
    User.current.getSongs(for: "tom  waits")
    .then { songs in
      self.songs = songs
    }
    .catch { error in
      self.showAlert(error)
    } 
  }

  private func showAlert(_ error: Error? = nil) {

  }

}

extension SearchViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    
  }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return songs.count
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return tableView
        .dequeueReusableHeaderFooterView(withIdentifier: "SongsHeader")
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "SongResultCell",
      for: indexPath
    )
    return cell
  }

}
