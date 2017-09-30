//
//  ArrayExtension.swift
//  RoomPainter
//
//  Created by keisyrzk on 09.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

extension Array
{
    func findElement(_ match: (Element) -> Bool) -> Element?
    {
        for element in self where match(element)
        {
            return element
        }
        return nil
    }
}
