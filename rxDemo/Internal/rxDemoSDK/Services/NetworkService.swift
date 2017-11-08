//
//  NetworkService.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum NetworkServiceError: Error {
    case wrongUrl
    case wrongMapping
}

class NetworkService {
    
    // MARK: Public Properties
    
    var configuration: NetworkServiceConfiguration
    
    var session: NetworkServiceSession?
    
    // MARK: Private Properties
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: Lyfecircle
    
    init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Public Methods
    
    func request<T: Codable>(method: Alamofire.HTTPMethod, endpoint: String, urlParameters: Parameters? = nil, bodyParameters: Parameters? = nil, HTTPHeaderFields: [String: String] = [:]) -> Observable<T> {
        do {
            let request = try constructRequest(with: method, endpoint: endpoint, urlParameters: urlParameters, bodyParameters: bodyParameters, HTTPHeaderFields: HTTPHeaderFields)
            return constructObservable(with: request)
        } catch let error {
            return Observable<T>.error(error)
        }
    }
    
    func request(method: Alamofire.HTTPMethod, endpoint: String, urlParameters: Parameters? = nil, bodyParameters: Parameters? = nil, HTTPHeaderFields: [String: String] = [:]) -> Observable<Void> {
        do {
            let request = try constructRequest(with: method, endpoint: endpoint, urlParameters: urlParameters, bodyParameters: bodyParameters, HTTPHeaderFields: HTTPHeaderFields)
            return constructVoidObservable(with: request)
        } catch let error {
            return Observable<Void>.error(error)
        }
    }
    
}

private extension NetworkService {
    
    func constructRequest(with method: Alamofire.HTTPMethod, endpoint: String, urlParameters: Parameters? = nil, bodyParameters: Parameters? = nil, HTTPHeaderFields: [String: String] = [:]) throws -> URLRequest {
        let urlString = configuration.baseUrl.absoluteString + endpoint
        guard let url = URL(string: urlString) else { throw NetworkServiceError.wrongUrl }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = configuration.httpHeaders + HTTPHeaderFields
        if let sessionHeaders = session?.httpHeaders {
            request.allHTTPHeaderFields = request.allHTTPHeaderFields! + sessionHeaders
        }
        if let urlParameters = urlParameters {
            request = try URLEncoding.queryString.encode(request, with: urlParameters)
        }
        if let bodyParameters = bodyParameters {
            request = try JSONEncoding.default.encode(request, with: bodyParameters)
        }
        return request
    }
    
    func attachNetworkActivityIndicationIfNeed(to observable: Observable<Any>) {
        if configuration.isNetworkActivityIndicatorVisible {
            let activity = Observable.merge(Observable.just(true), observable.map({ _ in return false })).asDriver(onErrorJustReturn: false)
            activity.drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: disposeBag)
        }
    }
    
    func constructObservable<T: Codable>(with request: URLRequest) -> Observable<T> {
        let observable = Observable<T>.create({ (subscriber) -> Disposable in
            let request = Alamofire.request(request).responseData(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    if let result = try? JSONDecoder().decode(T.self, from: value) {
                        subscriber.onNext(result)
                        subscriber.onCompleted()
                    } else {
                        subscriber.onError(NetworkServiceError.wrongMapping)
                    }
                case .failure(let error):
                    subscriber.onError(error)
                }
            })
            if self.configuration.isDebugEnabled == true {
                debugPrint(request)
            }
            return Disposables.create {
                request.cancel()
            }
        }).share()
        
        attachNetworkActivityIndicationIfNeed(to: observable.map({ $0 }))
        
        return observable
    }
    
    func constructVoidObservable(with request: URLRequest) -> Observable<Void> {
        let observable = Observable<Void>.create({ (subscriber) -> Disposable in
            let request = Alamofire.request(request).responseData(completionHandler: { (response) in
                switch response.result {
                case .success(_):
                    subscriber.onNext()
                    subscriber.onCompleted()
                case .failure(let error):
                    subscriber.onError(error)
                }
            })
            if self.configuration.isDebugEnabled == true {
                debugPrint(request)
            }
            return Disposables.create {
                request.cancel()
            }
        }).share()
        
        attachNetworkActivityIndicationIfNeed(to: observable.map({ $0 }))
        
        return observable
    }
    
}
