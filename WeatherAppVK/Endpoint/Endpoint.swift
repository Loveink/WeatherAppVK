//
//  Endpoint.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 25.03.2024.
//

import Foundation

// "http://api.weatherunlocked.com/api/current/55.7586642,37.6192919?app_id=cddce782&app_key=6889dd77e925fe59613db86d643f893e"
// "http://api.weatherunlocked.com/api/forecast/55.7586642,37.6192919?app_id=cddce782&app_key=6889dd77e925fe59613db86d643f893e"

struct Endpoint {
    let apiKey = "6889dd77e925fe59613db86d643f893e"
    let appId = "cddce782"

    //MARK: - Private properties
    private let path: String
    private let queryItems: [URLQueryItem]

    //MARK: - URL
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.weatherunlocked.com"
        components.path = "/api/".appending(path)
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Unable to create url from: \(components)")
        }
        return url
    }

    //MARK: - init(_:)
    init(
        path: String = .init(),
        queryItems: [URLQueryItem] = .init()
    ) {
        self.path = path
        self.queryItems = queryItems
    }

    //MARK: - Public methods
    @inlinable
    func path(_ p: String) -> Self {
        Endpoint(path: p, queryItems: queryItems)
    }

    @inlinable
    func appendPath(_ p: String) -> Self {
        Endpoint(path: path.appending(p), queryItems: queryItems)
    }

    @inlinable
    func addQueryItem(_ i: URLQueryItem) -> Self {
        var queryItems = queryItems
        queryItems.append(i)
        return Endpoint(path: path, queryItems: queryItems)
    }
}
