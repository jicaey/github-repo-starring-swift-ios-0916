//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.apiURL)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> ()) {
        var isStarred = false
        
        let url = URL(string: "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.accessToken)")
        guard let unwrappedUrl = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204 {
                isStarred = true
            } else {
                isStarred = false
            }
            completion(isStarred)
        }
        task.resume()
    }
    
    class func starRepository(named: String, completion: @escaping () -> ()) {
        
    
        let urlString = "\(Secrets.apiURL)/user/starred/\(named)?access_token=\(Secrets.accessToken)"
        let url = URL(string: urlString)
        guard let unwrappedUrl = url else { return }
        
        
        var request = URLRequest(url: unwrappedUrl)
        request.httpMethod = "PUT"
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 204 {
                completion()
            } else if httpResponse.statusCode == 404 {
                completion()
            }
        }
        
        task.resume()
        
    }
    
    class func unstarRepository(named: String, completion: @escaping () -> ()) {
        
        let urlString = "\(Secrets.apiURL)/user/starred/\(named)?access_token=\(Secrets.accessToken)"
        let url = URL(string: urlString)
        guard let unwrappedUrl = url else { return }
        
        var request = URLRequest(url: unwrappedUrl)
        request.httpMethod = "DELETE"
        
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 204 {
                completion()
            } else if httpResponse.statusCode == 404 {
                completion()
            }
        }
        
        task.resume()
        
    }

}

