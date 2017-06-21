//
//  SearchViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

// TODO: Add Recent Searches and persist to realmDB
class SearchViewController: UIViewController {

  @IBOutlet
  private weak var searchBar: UISearchBar!

  @IBOutlet
  private weak var tableView: UITableView!

  @IBOutlet
  private weak var activityIndicator: UIActivityIndicatorView!

  fileprivate var songs = [Song]() {
    didSet {
      tableView.contentOffset = .zero
      tableView.reloadData()
    }
  }

  private var isLoading: Bool = false {
    willSet {
      searchBar.isUserInteractionEnabled = !newValue
      tableView.allowsSelection = !newValue
      newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(
      UINib(nibName: "SongResultsTableHeaderView", bundle: nil),
      forHeaderFooterViewReuseIdentifier: "SongsHeader"
    )
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch (segue.destination, sender) {
    case (let viewController as LyricsViewController,
          let tableViewCell as SongTableViewCell):
      viewController.song = tableViewCell.song
    default:
      break
    }
  }

  fileprivate func search(with string: String?) {
    guard
      let term = string,
      !term.isEmpty
      else {
      tableView.isHidden = true
      isLoading = false
      return
    }
    isLoading = true
    tableView.isHidden = false
    Session.current.getSongs(for: term)
      .then { songs in
        self.songs = songs
      }
      .catch { error in
        self.showAlert(error)
      }
      .always {
        self.isLoading = false
    }
  }

  private func showAlert(_ error: Error? = nil) {

  }

}

extension SearchViewController: UISearchBarDelegate {

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(true, animated: true)
    return true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    search(with: searchBar.text)
    searchBar.resignFirstResponder()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search(with: searchBar.text)
    searchBar.resignFirstResponder()
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
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
    guard let songCell = cell as? SongTableViewCell else {
      return cell
    }
    songCell.song = songs[indexPath.row]
    return songCell
  }

}
