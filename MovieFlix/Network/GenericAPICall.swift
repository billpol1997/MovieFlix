//
//  GenericAPICall.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import Alamofire

class GenericAPICall {
    
    func fetchData<T: Decodable>(from url: String, method: HTTPMethod, headers: HTTPHeaders? = nil ,parameters: Parameters? = nil, responseModel: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
