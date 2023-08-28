//
//  CoreDataFeedStore.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 28/08/23.
//


import CoreData


// MARK: - CoreDataFeedStore class
public final class CoreDataFeedStore: FeedStoreProtocol {
    public init() {}
    
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}


// MARK: - ManagedCache class
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}


// MARK: - ManagedFeedImage class
private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
