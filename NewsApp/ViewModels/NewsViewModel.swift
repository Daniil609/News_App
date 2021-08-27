//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Tomashchik Daniil on 23/08/2021.
//

import Foundation
struct NewsViewModel {
    let new:Article
    
    var title:String{
        return new.title
    }
    
    var author:String{
        return new.title
    }
    var url:String{
        return new.url
    }
    var description:String{
        return new.description
    }
    var publishedAt:String{
        return new.publishedAt
    }
    var name:String{
        return new.source.name 
    }
   
    var urlToImage:String{
        return new.urlToImage ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-vector%2Fbreaking-news-banner-with-world-map-wallpaper_7798066.htm&psig=AOvVaw3FLvdlh6YItPYnZvQj1BuB&ust=1629801565681000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiTxp_6xvICFQAAAAAdAAAAABAD"
    }
    
}
