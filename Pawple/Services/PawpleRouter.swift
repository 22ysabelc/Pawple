//
//  PawpleRouter.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/27/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation
import Alamofire

enum PawpleRouter {
    case fetchListOfBreeds(String)
    case fetchListOfOrganizations
    case fetchAccessToken

    var baseURL: String {
        return "https://api.petfinder.com/v2/"
    }

    var path: String {
        switch self {
            case .fetchListOfBreeds(let species):
                return "types/\(species)/breeds/"
            case .fetchListOfOrganizations:
                return "/organizations"
            case .fetchAccessToken:
                return "/oauth2/token"
        }
    }

    var method: HTTPMethod {
        switch self {
            case .fetchAccessToken:
                return .post
            default:
                return .get
        }
    }

    var parameters: [String: String]? {
        switch self {
            case .fetchAccessToken:
                return [
                    "client_id": GitHubConstants.clientID,
                    "client_secret": GitHubConstants.clientSecret,
                    "grant_type": GitHubConstants.grantType
            ]
            case .fetchListOfBreeds(_):
            return nil
            case .fetchListOfOrganizations:
            return nil
        }
    }
}
// MARK: - URLRequestConvertible
extension PawpleRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder()
                .encode(parameters, into: request)
        } else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
