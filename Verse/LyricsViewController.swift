//
//  LyricsViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

private var favoriteImage: UIImage { return #imageLiteral(resourceName: "favorite-icon") }

protocol SongDelegate: class {

  func didToggleFavoriteSong(_ song: Song)

}

class LyricsViewController: UIViewController {

  var song: Song!

  weak var delegate: SongDelegate?

  @IBOutlet
  private weak var albumImageView: PhotoImageView!

  @IBOutlet
  private weak var songLabel: SongLabel!

  @IBOutlet
  private weak var albumLabel: SongLabel!

  @IBOutlet
  private weak var webView: UIWebView!

  @IBOutlet
  fileprivate weak var activityIndicator: UIActivityIndicatorView!

  @IBOutlet
  private weak var favoriteButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.scrollView.showsVerticalScrollIndicator = false
    albumImageView.photo = song.artwork
    songLabel.setName(for: song)
    albumLabel.text = song.album
    setFavorite()
    getLyrics()
  }

  @IBAction
  func saveTapped(_ sender: Any) {
    try? Session.current.favorite(song: song)
  }

  @IBAction
  func hideTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    view.backgroundColor = .clear
  }

  @IBAction
  func favoriteTapped(_ sender: Any) {
    song = Session.current.toggleFavorite(song: song)
    setFavorite()
    delegate?.didToggleFavoriteSong(song)
  }

  private func getLyrics() {
    Session.current.getLyrics(for: song)
      .then { [weak self] lyricsURL in
        self?.loadURL(lyricsURL)
      }
      .catch { [weak self] error in
        self?.showAlert(error: error)
    }
  }

  private func loadURL(_ url: URL) {
    webView.loadRequest(URLRequest(url: url))
  }

  private func showAlert(error: Error) {
    let alert = UIAlertController(
      title: "No Lyrics Found",
      message: nil,
      preferredStyle: .alert
    )
    alert.addAction(
      UIAlertAction(title: "Dismiss", style: .default) { _ in
        self.dismiss(animated: true, completion: nil)
      }
    )
    present(alert, animated: true, completion: nil)
  }

  private func setFavorite() {
    var image = favoriteImage
    if !Session.current.isFavorite(song: song.id) {
      image = image.tint(with: .lightGray)
    }
    favoriteButton.setImage(image, for: .normal)
  }

}

extension LyricsViewController: UIWebViewDelegate {

  func webViewDidFinishLoad(_ webView: UIWebView) {
    let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width
    webView.scrollView.setZoomScale(zoom, animated: false)
    activityIndicator.stopAnimating()
  }

}

private extension UIImage {

  func tint(with color: UIColor) -> UIImage {
    return withRenderingMode(.alwaysTemplate)
      .mask(with: color)
  }

  private func mask(with color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    guard let context = UIGraphicsGetCurrentContext() else {
      return self
    }
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(.normal)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    context.clip(to: rect, mask: cgImage!)
    color.setFill()
    context.fill(rect)
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
      return self
    }
    UIGraphicsEndImageContext()
    return newImage
  }
}
