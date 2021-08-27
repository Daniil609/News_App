//
//  APICaller.swift
//  NewsApp
//
//  Created by Tomashchik Daniil on 21/08/2021.
//

import Foundation

class APICaller {
    let imageCache = NSCache<NSString,NSData>()
    
    static let shared = APICaller()
    var topURL = ""
    var seartchURLString = ""
    
    private init(){}
    
    func getInfo(time:String,completion:@escaping(Result<[Article],Error>)->Void)  {
        topURL = "https://newsapi.org/v2/everything?q=Apple&pageSize=50&sortBy=popularity&apiKey=6d796a8545954efca84f7ddd00347adb&from=\(time)"
        seartchURLString = "https://newsapi.org/v2/everything?from=\(time)&sortBy=popularity&apiKey=6d796a8545954efca84f7ddd00347adb&q="
        let url = URL(string: topURL)
        
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print(result.articles.first?.publishedAt ?? "")
                    completion(.success(result.articles))
                    
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func loadMoreInformation(time:String,completion:@escaping(Result<[Article],Error>)->Void)  {
        topURL = "https://newsapi.org/v2/everything?q=Apple&pageSize=50&sortBy=popularity&apiKey=6d796a8545954efca84f7ddd00347adb&from=\(time)"
        seartchURLString = "https://newsapi.org/v2/everything?from=\(time)&sortBy=popularity&apiKey=6d796a8545954efca84f7ddd00347adb&q="
        let url = URL(string: topURL)
        
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print(result.articles.first?.publishedAt ?? "")
                    completion(.success(result.articles))
                    
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func seartch(with query:String, completion:@escaping(Result<[Article],Error>)->Void)  {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = seartchURLString + query
        topURL = urlString
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    completion(.success(result.articles))
                    print(result.articles.count)
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getImage(urlString:String,completion:@escaping(Data?)->Void){
        guard let url = URL(string: urlString) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: NSString(string:urlString)){
            completion(cachedImage as Data)
        }else{
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard  error == nil, let data = data else {
                    completion(nil)
                    return
                }
                self.imageCache.setObject(data as NSData, forKey: NSString(string: urlString))
                completion(data)
            }.resume()
        }
    }
    
    
}

