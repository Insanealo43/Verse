//
//  Service.swift
//  Verse
//
//  Created by Andrew Lopez-Vass on 6/19/17.
//  Copyright © 2017 ALV. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON

private var queue: DispatchQueue {
  return DispatchQueue.global(qos: .background)
}

class Service {

  enum URLs: String {

    case itunes = "https://itunes.apple.com/search"
    case lyrics = "http://lyrics.wikia.com/api.php"

  }

  enum Error: Swift.Error {

    case jsonSerialization(error: Swift.Error)
    
  }

  static let shared = Service()
  private let sessionManager: SessionManager

  init() {
    sessionManager = SessionManager(configuration: .default)
  }

  func request(url path: String,
               method: HTTPMethod,
               parameters: Parameters? = nil,
               encoding: ParameterEncoding = URLEncoding.default) -> Promise<JSON> {
    return sessionManager
      .request(
        URL(string: path)!,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: nil
      )
      .responseJSON()
  }

}

extension DataRequest {

  func responseJSON(queue: DispatchQueue? = queue,
                    options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<JSON> {
    return Promise { fulfill, reject in
      responseJSON(queue: queue, options: options) { response in
        switch response.result {
        case .success(let json):
          fulfill(JSON(json))
        case .failure(let error):
          if
            let data = response.data,
            let javascriptString = String(data: data, encoding: .utf8),
            let json = try? JSONSerialization.data(
              withJSONObject: [javascriptString],
              options: []) {
            fulfill(JSON(json))
          }
          else {
            reject(Service.Error.jsonSerialization(error: error))
          }
        }
      }
    }
  }

}
