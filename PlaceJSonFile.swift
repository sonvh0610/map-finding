//
//  PlaceJSonFile.swift
//  
//
//  Created by user137983 on 4/27/18.
//

import Foundation

struct location:Decodable{
    var lng:Double
    var lat:Double
}

struct geometry:Decodable {
    var location:location
}

struct iPlace:Decodable {
    
    var geometry:geometry
    var id: String
    var place_id :String
    var reference: String
}



struct myJSONFile:Decodable {
    var html_attributions:[String]
    var results:[iPlace]
    var status:String
    
}
