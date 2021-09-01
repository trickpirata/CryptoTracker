//
//  GPAPIService.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import Alamofire
import Combine

public protocol GPAPIServiceType {
    func request<T: Decodable>(resource: GPAPIResource) -> AnyPublisher<T, Error>
}

public class GPAPIService: GPAPIServiceType {
    public func request<T: Decodable>(resource: GPAPIResource) -> AnyPublisher<T, Error> {
        return AF.request(resource.fullURL,
                          method: resource.method,
                          parameters: resource.parameters,
                          encoding: resource.encoding,
                          headers: resource.headers)
            .publishDecodable(type: T.self)
            .tryCompactMap({ (response) -> T? in
                if let error = response.error { throw error }
                
                return response.value
            }).eraseToAnyPublisher()

    }
}
