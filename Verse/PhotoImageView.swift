//
//  PhotoImageView.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/21/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import AlamofireImage
import UIKit

class PhotoImageView: UIImageView {

  var photo: Photo! {
    didSet {
      if let data = photo.data {
        image = UIImage(data: data)
      }
      else {
        af_setImage(
          withURL: URL(string: photo.url)!,
          placeholderImage: nil
        ) { [weak self] response in
          guard
            let strongSelf = self,
            case let .success(image) = response.result,
            let data = UIImageJPEGRepresentation(image, 1.0)
            else {
            return
          }
          // TODO: upsert photo data into realm db
          strongSelf.photo.data = data
        }
      }
    }
  }

}
