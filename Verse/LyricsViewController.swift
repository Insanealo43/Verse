//
//  LyricsViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

// TODO: Add caching feature for 'favoriting' lyrics to realmDB
class LyricsViewController: UIViewController {

  var song: Song!

  @IBOutlet
  private weak var webView: UIWebView!

  @IBOutlet
  fileprivate weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.scrollView.showsVerticalScrollIndicator = false
    Session.current.getLyrics(for: song)
    .then { [weak self] lyricsURL in
      self?.loadURL(lyricsURL)
    }
    .catch { [weak self] error in
      self?.showAlert(error: error)
    }
  }

  @IBAction
  func hideTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    view.backgroundColor = .clear
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
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true, completion: nil)
  }

}

extension LyricsViewController: UIWebViewDelegate {

  func webViewDidFinishLoad(_ webView: UIWebView) {
    let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width
    webView.scrollView.setZoomScale(zoom, animated: false)
    activityIndicator.stopAnimating()
  }

}
