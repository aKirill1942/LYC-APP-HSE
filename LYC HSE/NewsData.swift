//
//  NewsData.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 21.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit
import CoreData

class NewsData: NSObject {
    @NSManaged var id: Int64
    @NSManaged var tagId: Int64
    @NSManaged var watches: Int64
    @NSManaged var newsContent: String?
    @NSManaged var newsShortDescription: String?
    @NSManaged var newsTitle: String?
    @NSManaged var photoURL: String?
    @NSManaged var postTime: NSDate?
}
