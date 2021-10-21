//
//  AuthPlugin.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Foundation
import Moya

// MARK: - Authentication Plugin

struct AuthPlugin: PluginType {
    let token: String

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.url = request.url?.appending("api_key", value: token)
        return request
    }
}
