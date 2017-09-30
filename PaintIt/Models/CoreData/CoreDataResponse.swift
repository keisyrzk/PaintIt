//
//  CoreDataResponse.swift
//  RoomPainter
//
//  Created by keisyrzk on 23.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import CoreData

struct EmptyResponse
{
    // EMPTY IMPLEMENTATION
}


enum Result<T>
{
    case success(T)
    case failure(NSError)
}
