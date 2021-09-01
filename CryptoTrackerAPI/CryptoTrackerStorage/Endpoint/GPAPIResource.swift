//
//  GPAPIResource.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import Alamofire

private struct CONFIG {
    static let API = "https://api.coingecko.com/api"
}

enum GPAPIVersion: String {
    case v1 = "/v1"
    case v2 = "/v2"
    case v3 = "/v3"
}

public enum GPAPIResource {
    case coinList
    case markets(currency: String, cryptoIDs: String,page: Int)
    case marketChart(currency: String, id: String, days: Int)
}

extension GPAPIResource {
    var baseURL: URL {
        return URL(string: CONFIG.API)!
    }
    
    var path: String {
        switch self {
        case .coinList:
            return "/coins/list"
        case .markets:
            return "/coins/markets"
        case .marketChart(currency: _, id: let id, days: _):
            return "/coins/\(id)/market_chart"
        }
    }
    
    var version: GPAPIVersion {
        return .v3
    }
    
    var parameters: Parameters? {
        switch self {
        case .coinList:
            return nil
        case .markets(currency: let currency, cryptoIDs: let cryptos, page: let page):
            return [
                "vs_currency": currency,
                "ids": cryptos,
                "order": "market_cap_desc",
                "per_page": 250,
                "page": page,
                "sparkline": "false",
                "price_change_percentage": "1h,24h,7d,30,1y"
            ]
        case .marketChart(currency: let currency, id: _, days: let days):
            return [
                "vs_currency": currency,
                "days": days,
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .coinList,
             .markets,
             .marketChart:
            return .get
        }
        
    }
    
    private var defaultHeaders: HTTPHeaders {
        return [ ]
    }
    
    var headers: HTTPHeaders {
        let defaultHeaders = self.defaultHeaders
        switch self {
        default: break
        }
        return defaultHeaders
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var fullURL: String {
        return "\(baseURL)\(version.rawValue)\(path)"
    }
    
    var decoder: DataDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
