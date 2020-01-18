//
//  GitHubAPIV4.swift
//  GitHub
//
//  Created by Rafael Escaleira on 14/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

struct GitHubAPIV4 {
    
    static let clientID = "Iv1.cda9c3058a98dc72"
    static let clientSecret = "7e9bf73a03a93615a7ef966bc29546ac6a4cb690"
    static let redirectURI = "https://rafaelescaleira.github.io/GitHub/"
    static let scope = "read:user,user:email"
    static let tokenURL = "https://github.com/login/oauth/access_token"
    
    static let repositories = "https://api.github.com/users/rafaelescaleira/repos"
    
    static func getURL() -> URL? {
        
        let uuid = UUID().uuidString
        let urlString = "https://github.com/login/oauth/authorize?client_id=" + clientID + "&scope=" + scope + "&redirect_uri=" + redirectURI + "&state=" + uuid
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    static func requestForCallbackURL(urlString: String, handler: @escaping (Bool) -> ()) {
        
        print(urlString)
        
        guard let range = urlString.range(of: "=") else { handler(false); return }
        let githubCode = urlString[range.upperBound...]
        guard let rangeFinal = githubCode.range(of: "&state=") else { handler(false); return }
        let githubCodeFinal = githubCode[..<rangeFinal.lowerBound]
        githubRequestForAccessToken(authCode: String(githubCodeFinal))
        
        DispatchQueue.main.async { handler(true) }
    }
    
    static func githubRequestForAccessToken(authCode: String) {
        
        let grantType = "authorization_code"
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + clientID + "&client_secret=" + clientSecret
        let postData = postParams.data(using: String.Encoding.utf8)
        
        guard let tokenURL = URL(string: tokenURL) else { return }
        
        let request = NSMutableURLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error != nil { return }
            
            do {
                
                guard let results = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                guard let accessToken = results["access_token"] as? String else { return }
                print(accessToken)
            }
            
            catch {  }
        }
        
        task.resume()
    }
    
    static func getRepositories(urlString: String, completion: @escaping ([RepositoriesCodable]) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let codable = try JSONDecoder().decode([RepositoriesCodable].self, from: data)
                
                DispatchQueue.main.async { completion(codable) }
            }
                
            catch {}
            
        }).resume()
    }
    
    static func getContents(urlString: String, completion: @escaping ([ContentsCodable]) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let codable = try JSONDecoder().decode([ContentsCodable].self, from: data)
                
                DispatchQueue.main.async { completion(codable) }
            }
                
            catch {}
            
        }).resume()
    }
}
