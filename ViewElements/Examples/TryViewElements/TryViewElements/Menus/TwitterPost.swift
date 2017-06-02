//
//  TwitterPost.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

struct TwitterPost: Equatable {
    let userPic: UIImage
    let author: String
    let username: String
    let relativeDate: String
    let content: String
    let image: UIImage?
}

func == (lhs: TwitterPost, rhs: TwitterPost) -> Bool {
    return lhs.author == rhs.author && lhs.content == rhs.content && lhs.username == rhs.username
}

func mockPost() -> TwitterPost {
    let rnd = arc4random() % 4
    switch rnd {
    case 0:
        return TwitterPost(userPic: #imageLiteral(resourceName: "user1.jpg"), author: "Steven Rattner", username: "@SteveRatner", relativeDate: "18h", content: "A poor elderly person w/ income of $26,500 would pay net premium of\n- $1,700 under Obamacare\n- $13,500-16,100 under AHCA\n800-947% increase!", image: #imageLiteral(resourceName: "img1.png"))
    case 1:
        return TwitterPost(userPic: #imageLiteral(resourceName: "user2.jpg"), author: "Sebastian Pokutta", username: "@spokutta", relativeDate: "17h", content: "It's easy to transform and move your data on the cloud using Xplenty, a data integration service, no coding requred", image: nil)
    case 2:
        return TwitterPost(userPic: #imageLiteral(resourceName: "logo.png"), author: "Wirawit Rueopas", username: "@aunnnn", relativeDate: "now", content: "At last, I'm freed from all duties. However, sometimes it seems too free...", image: #imageLiteral(resourceName: "cog.jpg"))
    case 3:
        return TwitterPost(userPic: #imageLiteral(resourceName: "user3.jpg"), author: "Michel AvantGarde", username: "@michelavnt", relativeDate: "12h", content: "Look at this cog! It's gorgeous is'nt it???", image: nil)
    default:
        return TwitterPost(userPic: #imageLiteral(resourceName: "user1.jpg"), author: "Steven Rattner", username: "@SteveRatner", relativeDate: "18h", content: "A poor elderly person w/ income of $26,500 would pay net premium of\n- $1,700 under Obamacare\n- $13,500-16,100 under AHCA\n800-947% increase!", image: nil)
    }
}
