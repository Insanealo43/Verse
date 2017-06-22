//
//  UIView+IBInspectables.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import UIKit

extension UIView {

  @IBInspectable
  var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

}
