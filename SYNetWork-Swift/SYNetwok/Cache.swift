//
//  SYCache.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation

public class Cache {
    
    
    let manager: NSCache = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 1000
        return cache
    }()
    
    /// 单例方法
    static let shared = Cache()
    private init() {}
    
    // MARK - 增删改查
    public func save(_ data: Data!, for request: Request) {
        self.save(data, for: self.key(for: request))
    }
    
    public func fetch(for request: Request) -> Data?{
        return self.fetch(for: self.key(for: request))
    }
    
    public func delete(for request: Request) {
        self.delete(for: self.key(for: request))
    }
    
    public func clean() {
        manager.removeAllObjects()
        DiskCache.shared.clean()
    }
    
    
    private func fetch(for key: String!) -> Data? {
        let data = self.manager.object(forKey: key as AnyObject) as! CacheObject
        if data.isEmpty() {
            DiskCache.shared.fetch(for: key, objectGetHandler: { (obj) in
                if (obj?.isEmpty())! || (obj?.isOutDated())! {
                    // TO: 删除某条数据
                }
            })
        }
        if data.isEmpty() || data.isOutDated() {
            self.delete(for: key)
            return nil
        }
        return data.content
    }
    
    private func save(_ data: Data!, for key:String!) {
        var cache: CacheObject? = self.manager.object(forKey: key as AnyObject) as? CacheObject
        if  cache == nil {
            cache = CacheObject(data: data)
        }
        cache!.update(data: data)
        self.manager.setObject(cache!, forKey: key as AnyObject)
    }
    
    /// 按照 key 值删除缓存
    ///
    /// - Parameter key: key 值
    private func delete(for key: String!) {
        self.manager.removeObject(forKey: key as AnyObject)
        DiskCache.shared.clean()
    }
    
    /// 生成存取缓存的key
    ///
    /// - Parameter request: 请求
    /// - Returns: key 值
    func key(for request: Request) -> String {
        let keyArray = request.parameters.keys
            .sorted { (fhs, lhs) -> Bool in return fhs > lhs }
        
        var res = ""
        keyArray.forEach { (key) in
            res.append("\(key.lowercased(), request.parameters[key])")
        }
        return "\(request.path)\(request.url)\(res)"
    }
}



// MARK: - DiskCache
fileprivate class DiskCache {
    
    enum CacheFor: String {
        case network = "SYNetwork_Swift"
    }
    
    private let defaultCacheName = "SY_default"
    private let cachePrex = "com.sy.network.cache."
    private let ioQueueName = "com.sy.network.cache.ioQueue."
    
    private var fileManager = FileManager.default
    private let ioQueue: DispatchQueue?
    var diskCachePath: String?
    private var storeType: CacheFor
    
    // 暂时这样, 虽然这样处理不对
    static let shared = DiskCache(type: .network)

    init(type:CacheFor) {
        storeType = type
        let cacheName = cachePrex + type.rawValue
        ioQueue = DispatchQueue(label: ioQueueName + type.rawValue)
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        diskCachePath = (paths.first! as String).appending(cacheName)
        
        ioQueue?.sync {
            do {
                try fileManager.createDirectory(atPath: self.diskCachePath!, withIntermediateDirectories: true, attributes: nil)
            } catch _ {}
        }
    }
    
    
    func store(_ resp: CacheObject!, for key: String) {
        let data = NSMutableData()
        let keyArchiver = NSKeyedArchiver.init(forWritingWith: data)
        keyArchiver.encode(resp, forKey: key)
        keyArchiver.finishEncoding()
        do {
            try data.write(toFile: key , options: .atomicWrite)
        } catch let err {
            print("SYNetwork,write to disk error: \(err.localizedDescription)")
        }
    }
    
    func fetch(for key: String, objectGetHandler:((_ obj:CacheObject?) -> ())?) {
        let path = diskCachePath?.appending(key)
        switch storeType {
        case .network:
            DispatchQueue.global().async {
                if self.fileManager.fileExists(atPath: path!) {
                    let data: Data = self.fileManager.contents(atPath: path!)!
                    let unArchiver = NSKeyedUnarchiver(forReadingWith: data)
                    let obj = unArchiver.decodeObject(forKey: key)
                    objectGetHandler?(obj as? CacheObject)
                }
                objectGetHandler?(nil)
            }
        }
    }
    
    func clean() {
        let directory = cachePrex + storeType.rawValue
        try! fileManager.removeItem(atPath: directory)
    }
}

/// 缓存的对象
private class CacheObject: NSCoding {
    
    fileprivate(set) var content: Data? {
        didSet {
            lastUpdatetime = Date(timeIntervalSinceNow: 0)
        }
    }
    fileprivate(set) var lastUpdatetime: Date!
    
    convenience init(data: Data) {
        self.init(data: data)
        content = data
    }
    
    fileprivate func update(data: Data!) {
        content = data
    }
    
    func isEmpty() -> Bool {
        return content == nil
    }
    
    func isOutDated() -> Bool {
        let timeInterval: TimeInterval = Date().timeIntervalSince(lastUpdatetime)
        
        return timeInterval > 300
    }
    
    // MARK - 序列化
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.content, forKey:"content")
        aCoder.encode(self.lastUpdatetime, forKey: "lastUpdatetime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.content = aDecoder.decodeObject(forKey: "content") as? Data
        self.lastUpdatetime = aDecoder.decodeObject(forKey: "lastUpdatetime") as? Date
    }
    
}

