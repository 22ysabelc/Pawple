//
//  APIServiceManager.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/27/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Alamofire

class APIServiceManager {
    static let shared = APIServiceManager()

    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
            })

        let interceptor = GitRequestInterceptor()

        return Session(
            configuration: configuration,
            interceptor: interceptor,
            cachedResponseHandler: responseCacher,
            eventMonitors: [])
    }()


    func fetchAccessToken(completion: @escaping (Bool) -> Void) {
        sessionManager.request(PawpleRouter.fetchAccessToken as URLRequestConvertible)
            .responseDecodable(of: GitHubAccessToken.self) { response in
                guard let token = response.value else {
                    return completion(false)
                }
                TokenManager.shared.saveAccessToken(gitToken: token)
                TokenManager.shared.saveTokenExpiration(gitToken: token)
                completion(true)
        }
    }

    func searchBreeds(species: String, completion: @escaping ([Name?]) -> Void) {
        sessionManager.request(PawpleRouter.fetchListOfBreeds(species) as URLRequestConvertible)
            .responseDecodable(of: Breeds.self) { response in
                guard let animalBreedNames = response.value?.breeds else {
                    return completion([])
                }
                completion(animalBreedNames)
        }
    }
}
