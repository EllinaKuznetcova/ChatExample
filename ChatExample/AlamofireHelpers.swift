//
//  AlamofireHelpers.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 03.08.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension DataRequest {
    
    func responseObject<T: Mappable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else {
                return DataRequest.handleErrors(response, error: error!, data: data)
            }
            
            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            switch result {
            case .success(let value):
                
                guard let json = value as? [String : AnyObject] else {
                    return .failure(RTError(serialize: .wrongType))
                }
                
                guard var object = T(JSON: json) else {return .failure(RTError(serialize: .requeriedFieldMissing))}
                
                object = Mapper<T>().map(JSONObject: json, toObject: object)
                
                return .success(object)
                
            case .failure(_):
                if let object = T(JSON: [:]) , data?.count == 0 {
                    return .success(object)
                }
                return .failure(RTError(serialize: .jsonSerializingFailed))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    class func handleErrors<T: Mappable>(_ response: HTTPURLResponse?, error: Swift.Error, data: Data?) -> Result<T> {
        do {
            guard let lData = data, let json = try JSONSerialization.jsonObject(with: lData as Data, options: []) as? [String : AnyObject] else {
                return .failure(RTError(serialize: .wrongType))
            }
            print(json)
            
            
        }
        catch let error {
            print(error)
        }
        return .failure(RTError(request: .unknown(error: error)))
    }
}
