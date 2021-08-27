//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Tomashchik Daniil on 23/08/2021.
//

import Foundation
class NewsListViewModel{
    
    //MARK: - let
    let reusedID = "news"
    
    //MARK: - var
    var newsVM = [NewsViewModel]()
    var countOfTime = 1
    
    //MARK:- func
    func getNews(copletion:@escaping([NewsViewModel])-> Void)  {
        APICaller.shared.getInfo(time:  date()) {[weak self] result in
            switch result{
            case.success(let result):
                let newsVM = result.map(NewsViewModel.init)
                DispatchQueue.main.async {
                    self?.newsVM = newsVM
                    print(newsVM.count)
                    copletion(newsVM)
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func moreInfo(copletion:@escaping([NewsViewModel])-> Void){
        APICaller.shared.loadMoreInformation(time: date()){ [weak self] result in
            switch result{
            case.success(let result):
                let newsVM = result.map(NewsViewModel.init)
                DispatchQueue.main.async {
                    for element in newsVM{
                        self?.newsVM.append(element)
                    }
                    print(newsVM.count)
                    
                    copletion(newsVM)
                }
            case.failure(let error):
                print(error)
            }
        }
        
    }
    
    func getNewsFromSeartch(text:String,copletion:@escaping([NewsViewModel])-> Void)  {
        APICaller.shared.seartch(with: text, completion: {[weak self] result in
            switch result{
            case.success(let result):
                let newsVM = result.map(NewsViewModel.init)
                DispatchQueue.main.async {
                    self?.newsVM = newsVM
                    print(newsVM.count)
                    
                    copletion(newsVM)
                }
            case.failure(let error):
                print(error)
            }
        })
    }
    
    func date()->String  {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "yyyy"
        let yearNow = Int(formatter.string(from: date))
        formatter.dateFormat = "MM"
        let mounthNow = Int(formatter.string(from: date))
        formatter.dateFormat = "dd"
        let dayNow = Int(formatter.string(from: date))
        formatter.dateFormat = "HH"
        
        let hourNow = Int(formatter.string(from: date))
        let now = DateComponents(calendar: Calendar.current, year: yearNow , month: mounthNow, day: dayNow,hour: hourNow)
        let later = Calendar.current.date(byAdding: .hour ,value: -24 * countOfTime ,to: now.date ?? Date())
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let res = formatter.string(from: later ?? Date())
        return res
    }
}
