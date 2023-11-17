//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 17/11/23.
//


import EssentialFeedJorge


// MARK: - FeedLoaderWithFallbackComposite
public class FeedLoaderWithFallbackComposite: FeedLoaderProtocol {
    private let primary: FeedLoaderProtocol
    private let fallback: FeedLoaderProtocol
    
    
    public init(primary: FeedLoaderProtocol, fallback: FeedLoaderProtocol) {
        self.primary = primary
        self.fallback = fallback
    }
    
    
    public func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        primary.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self.fallback.load(completion: completion)
            }
        }
    }
}
