//
//  CoreDataHelpers.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 28/08/23.
//


import CoreData


// MARK: - Extension. NSPersistentContainer
extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {    
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        
        try loadError.map { throw $0 }
        
        return container
    }
}


// MARK: - Extension. NSManagedObjectModel
extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
