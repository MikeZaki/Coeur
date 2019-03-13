//
//  UIImageURLExtension.swift
//  Coeur
//
//  Created by Michael Zaki on 3/12/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

extension UIImageView {
  public func image(fromUrl url: URL) {
    let theTask = URLSession.shared.dataTask(with: url) {
      data, response, error in
      if let response = data {
        DispatchQueue.main.async {
          self.image = UIImage(data: response)
        }
      }
    }
    theTask.resume()
  }
}
