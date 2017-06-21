//
//  LyricsViewController.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController {

  var song: Song!

  override func viewDidLoad() {
    super.viewDidLoad()
    Session.current.getLyrics(for: song)
    .then { lyrics in
      print("")
    }
    .catch { error in
      print("")
    }
  }

  @IBAction
  func hideTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    view.backgroundColor = .clear
  }

}
