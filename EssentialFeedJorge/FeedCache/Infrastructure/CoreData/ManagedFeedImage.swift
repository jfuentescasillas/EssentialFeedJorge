//
//  ManagedFeedImage.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 28/08/23.
//


import CoreData


// MARK: - ManagedFeedImage class
@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
    
}


// MARK: - Extension. ManagedFeedImage
extension ManagedFeedImage {
    internal static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let managedImgs = NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            
            return managed
        })
        
        return managedImgs
    }

    
    internal var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }
}

