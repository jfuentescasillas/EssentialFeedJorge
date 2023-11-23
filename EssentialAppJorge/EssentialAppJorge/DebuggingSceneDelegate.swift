//
//  DebuggingSceneDelegate.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 23/11/23.
//


#if DEBUG
import UIKit
import EssentialFeedJorge


class DebuggingSceneDelegate: SceneDelegate {
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
               
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    
    override func makeRemoteClient() -> HTTPClientProtocol {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return AlwaysFailingHTTPClient()
        }
        
        return super.makeRemoteClient()
    }
}


// MARK: - Class. AlwaysFailingHTTPClient
private class AlwaysFailingHTTPClient: HTTPClientProtocol {
    private class Task: HTTPClientTask {
        func cancel() { }
    }
    
    
    func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) -> HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        
        return Task()
    }
}
#endif
