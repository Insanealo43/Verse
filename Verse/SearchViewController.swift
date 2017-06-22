//
//  SearchViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  enum Mode {

    case favorites
    case results

  }

  @IBOutlet
  fileprivate weak var searchBar: UISearchBar!

  @IBOutlet
  fileprivate weak var tableView: UITableView!

  @IBOutlet
  private weak var activityIndicator: UIActivityIndicatorView!

  fileprivate var mode: Mode = .favorites {
    didSet {
      if mode != oldValue {
        tableView.contentOffset = .zero
        tableView.reloadData()
      }
    }
  }

  private(set) lazy var favoriteSongs = Session.current.favoriteSongs

  fileprivate var songs: Array<Song> = [] {
    didSet {
      tableView.contentOffset = .zero
      tableView.reloadData()
      if songs.isEmpty {
        showAlert()
      }
    }
  }

  fileprivate var numberSongs: Int {
    switch mode {
    case .favorites:
      return favoriteSongs.count
    case .results:
      return songs.count
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
    if favoriteSongs.isEmpty {
      searchBar.becomeFirstResponder()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch (segue.destination, sender) {
    case (let viewController as LyricsViewController,
          let tableViewCell as SongTableViewCell):
      viewController.song = Song(value: tableViewCell.song)
      viewController.delegate = self
    default:
      break
    }
  }

  fileprivate func search(with string: String?) {
    guard
      let term = string,
      !term.isEmpty
      else {
      mode = .favorites
      isLoading = false
      return
    }
    isLoading = true
    mode = .results
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

  fileprivate func song(for indexPath: IndexPath) -> Song {
    switch mode {
    case .favorites:
      return favoriteSongs[indexPath.row]
    case .results:
      return songs[indexPath.row]
    }
  }

}

extension SearchViewController: UISearchBarDelegate {

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(true, animated: true)
    return true
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      search(with: nil)
    }
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
    return numberSongs
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView
      .dequeueReusableHeaderFooterView(withIdentifier: "SongsHeader")
    guard let songsHeader = header as? SongResultsTableHeaderView else {
      return nil
    }
    switch (section, mode) {
    case (0, .favorites):
      songsHeader.title = "Favorite Songs"
    case (0, .results):
      songsHeader.title = "Song Results"
    default:
      return nil
    }
    return songsHeader
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
    songCell.song = song(for: indexPath)
    return songCell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return mode == .favorites
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      try! Session.current.unfavorite(song: song(for: indexPath))
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

}

extension SearchViewController: SongDelegate {

  func didToggleFavoriteSong(_ song: Song) {
    tableView.reloadData()
  }

}
