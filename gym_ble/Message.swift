//
//  Message.swift
//  gym_ble
//
//  Created by 山下克宏 on 2022/07/02.
//

import Foundation

class Message {
    
    var id: UInt16 = 0
        
    var value: Float = 0.0
    
    init (id: UInt16, value: Float) {
        self.id = id
        self.value = value
    }
    
    init(data: Data) {
        id = Data(data[0...1]).withUnsafeBytes { $0.load( as: UInt16.self ) }
        value = Data(data[2...5]).withUnsafeBytes { $0.load( as: Float.self ) }
    }
    
    func toData() -> Data {
        var data = Data(bytes: &id, count: MemoryLayout.size(ofValue: id))
        data.append(Data(bytes: &value, count: MemoryLayout.size(ofValue: value)))
        return data
    }
}
