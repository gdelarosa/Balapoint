//
//  Hashtag.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/6/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import Foundation
import Firebase

class Hashtag {
    var hashtag: String?
}

extension Hashtag {
    
    static func transformHashtag(dict: [String: Any], key: String) -> Hashtag {
        let tag = Hashtag()
        tag.hashtag = dict["hashtag"] as? String
        return tag
    }
}
