//
//  SimpleCache.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/1.
//

import UIKit

class SimpleCache<Key,Value> where Key: Hashable {
    
    private let lock: DispatchSemaphore
    private var map: [Key : Value]
    
    init() {
        self.lock = DispatchSemaphore(value: 1)
        self.map = Dictionary<Key, Value>()
    }
}

extension SimpleCache {
    
    subscript(key: Key)->Value? {
        get {
            return value(key)
        }
        set(newValue) {
            cache(newValue, key)
        }
    }
}

extension SimpleCache {
    
    /// 清空缓存
    func clear() {
        self.lock.wait()
        if(!self.map.isEmpty) { self.map.removeAll() }
        self.lock.signal()
    }
    
    /// 缓存中的所有的值
    var values: [Value]? {
        self.lock.wait()
        var _values = self.map.isEmpty ? nil : [Value]()
        if nil != _values {
            for value in self.map.values {
                _values!.append(value)
            }
        }
        self.lock.signal()
        return _values
    }
    
    /// 缓存中的所有的键
    var keys: [Key]? {
        self.lock.wait()
        var _keys = self.map.isEmpty ? nil : [Key]()
        if nil != _keys {
            for key in self.map.keys {
                _keys!.append(key)
            }
        }
        self.lock.signal()
        return _keys
    }
    
}

fileprivate extension SimpleCache {
    
    func cache(_ value: Value?, _ forKey: Key) {
        self.lock.wait()
        guard let unwrappedValue = value else {
            self.map.removeValue(forKey: forKey)
            self.lock.signal()
            return
        }
        self.map[forKey] = unwrappedValue
        self.lock.signal()
    }
    
    func value(_ forKey: Key)->Value? {
        self.lock.wait()
        let v = self.map[forKey]
        self.lock.signal()
        return v
    }
}
