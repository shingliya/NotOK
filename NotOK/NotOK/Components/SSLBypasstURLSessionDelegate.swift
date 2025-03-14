//
//  SSLBypasstURLSessionDelegate.swift
//  NotOK
//
//  Created by Tan Xin Jie on 14/3/25.
//

import Foundation

class SSLBypasstURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
