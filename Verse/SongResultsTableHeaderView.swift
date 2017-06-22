//
//  SongResultsTableHeaderView.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/20/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

class SongResultsTableHeaderView: UITableViewHeaderFooterView {

  var title: String? {
    get { return headerLabel.text }
    set {
      headerLabel.text = newValue
    }
  }

  @IBOutlet
  private weak var headerLabel: UILabel!

}
