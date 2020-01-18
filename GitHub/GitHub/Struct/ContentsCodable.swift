//
//  ContentsCodable.swift
//  GitHub
//
//  Created by Rafael Escaleira on 15/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

struct ContentsCodable: Codable {
    
    let name : String?
    let path : String?
    let sha : String?
    let size : Int?
    let url : String?
    let html_url : String?
    let git_url : String?
    let download_url : String?
    let type : String?
    let links : LinksCodable?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case path = "path"
        case sha = "sha"
        case size = "size"
        case url = "url"
        case html_url = "html_url"
        case git_url = "git_url"
        case download_url = "download_url"
        case type = "type"
        case links = "_links"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        sha = try values.decodeIfPresent(String.self, forKey: .sha)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        html_url = try values.decodeIfPresent(String.self, forKey: .html_url)
        git_url = try values.decodeIfPresent(String.self, forKey: .git_url)
        download_url = try values.decodeIfPresent(String.self, forKey: .download_url)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        links = try values.decodeIfPresent(LinksCodable.self, forKey: .links)
    }

}

struct LinksCodable: Codable {
    
    let selfLink : String?
    let git : String?
    let html : String?

    enum CodingKeys: String, CodingKey {

        case selfLink = "self"
        case git = "git"
        case html = "html"
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        selfLink = try values.decodeIfPresent(String.self, forKey: .selfLink)
        git = try values.decodeIfPresent(String.self, forKey: .git)
        html = try values.decodeIfPresent(String.self, forKey: .html)
    }
}
