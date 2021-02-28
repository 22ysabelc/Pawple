//
//  RequestInterceptor.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/27/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Alamofire

class GitRequestInterceptor: RequestInterceptor {
    //1
    let retryLimit = 3
    let retryDelay: TimeInterval = 10
    //2
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest
        TokenManager.shared.fetchAccessToken { (token) in
            if let token = token {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if
            let statusCode = response?.statusCode,
            (500...599).contains(statusCode),
            request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
