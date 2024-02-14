//
//  CombineHelpers.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 29/11/23.
//


import Foundation
import Combine
import EssentialFeedJorge


public extension Paginated {
    var loadMorePublisher: (() -> AnyPublisher<Self, Error>)? {
        guard let loadMore else { return nil }
        
        return {
            Deferred {
                Future(loadMore)
            }.eraseToAnyPublisher()
        }
    }
}


// MARK: - Extension. HTTPClientProtocol
public extension HTTPClientProtocol {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>

    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?

        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}


// MARK: - Extension. FeedImageDataLoader
public extension FeedImageDataLoaderProtocol {
    typealias Publisher = AnyPublisher<Data, Error>
    
    
    func loadImageDataPublisher(from url: URL) -> Publisher {
        var task: FeedImageDataLoaderTask?
        
        return Deferred {
            Future { completion in
                task = self.loadImageData(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}


extension Publisher where Output == Data {
    func caching(to cache: FeedImageDataCacheProtocol, using url: URL) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { data in
            cache.saveIgnoringResult(data, for: url)
        }).eraseToAnyPublisher()
    }
}


private extension FeedImageDataCacheProtocol {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save (data, for: url) { _ in }
    }
}


// MARK: - Extension. FeedLoaderProtocol
public extension LocalFeedLoader {
    typealias Publisher = AnyPublisher<[FeedImage], Error>
    
    
    func loadPublisher() -> Publisher {
        return Deferred {
            Future(self.load)
        }
        .eraseToAnyPublisher()
    }
}


// MARK: - Extension. FeedCacheProtocol
private extension FeedCacheProtocol {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}


// MARK: - Extension. Publisher
extension Publisher where Output == [FeedImage] {
    func caching(to cache: FeedCacheProtocol) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}


extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        return self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}


extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        return receive(on: DispatchQueue.immediateWhenOnMainQueueShceduler).eraseToAnyPublisher()
    }
}


// MARK: - Extension. DispatchQueue
extension DispatchQueue {
    static var immediateWhenOnMainQueueShceduler: ImmediateWhenOnMainQueueShceduler {
        return ImmediateWhenOnMainQueueShceduler.shared
    }
    
    
    struct ImmediateWhenOnMainQueueShceduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            return DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            return DispatchQueue.main.minimumTolerance
        }
        
        
        static let shared = Self()
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        
        private func isMainQueue() -> Bool {
            return DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        
        func schedule(options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }
        
        
        func schedule(after date: DispatchQueue.SchedulerTimeType, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        
        func schedule(after date: DispatchQueue.SchedulerTimeType, interval: DispatchQueue.SchedulerTimeType.Stride, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            return DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
