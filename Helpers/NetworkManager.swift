//
//  NetworkManager.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import Foundation

protocol NetworkDelegate: class {
    func showMessage(message: String)
}

class NetworkManager {
    private var host: String?
    private var port: Int?
    weak var delegate: NetworkDelegate?

    static let shared = NetworkManager(host: "127.0.0.1", port: 8050)

    private init(host: String, port: Int) {
        self.host = host
        self.port = port
    }

    func login(username: String, password: String) { }

    private func makeRequest(path: String, data: Data?, httpMethod: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.path = path

        var request = URLRequest(url: urlComponents.url!)
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        if let token = UserDefaults.standard.string(forKey: "token") {
            headers["Authorization"] = "Token \(token)"
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod
        request.httpBody = data
        return request
    }

    func dispatchRequest(request: URLRequest, completion: @escaping (Data) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                self.delegate?.showMessage(message: error!.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                switch httpResponse.statusCode {
                case 100..<400:
                    break
                case 400..<500:
                    self.delegate?.showMessage(message: "Looks like you provided the data we couldn't find!")
                    return
                case 500..<600:
                    self.delegate?.showMessage(message: "Error occured on the server. Please contact admin")
                    return
                default:
                    self.delegate?.showMessage(message: "Unable to handle response from server")
                }
            } else {
                self.delegate?.showMessage(message: "Invalid response from server")
                return
            }

            if let myData = data {
                completion(myData)
            } else {
                self.delegate?.showMessage(message: "no readable data received in response")
            }
        }
        task.resume()
    }

    func get(path: String, completion: @escaping (Data) -> Void) {
        let request = makeRequest(path: path, data: nil, httpMethod: "GET")
        dispatchRequest(request: request) { (data) in
            completion(data)
        }
    }

    func post(path: String, data: Data, completion: @escaping (Data) -> Void) {
        let request = makeRequest(path: path, data: data, httpMethod: "POST")
        dispatchRequest(request: request) { (myData) in
            completion(myData)
        }
    }
}
