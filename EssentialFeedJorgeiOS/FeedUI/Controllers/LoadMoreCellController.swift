//
//  LoadMoreCellController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 06/02/24.
//


import UIKit
import EssentialFeedJorge


public class LoadMoreCellController: NSObject {
    private let cell = LoadMoreCell()
    private let callback: () -> Void
    
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    
    private func reloadIfNeeded() {
        guard !cell.isLoading else { return }
        
        callback()
    }
}


// MARK: - Extension. UITableViewDataSource
extension LoadMoreCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
}


// MARK: - Extension. UITableViewDataSource
extension LoadMoreCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }
}


// MARK: - Extension. ResourceLoadingViewProtocol
extension LoadMoreCellController: ResourceLoadingViewProtocol {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}


// MARK: - Extension. ResourceErrorViewProtocol
extension LoadMoreCellController: ResourceErrorViewProtocol {
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
}


/*  ACTUALIZACIÓN PENDIENTE
 
public class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
   private let cell = LoadMoreCell()
    private let callback: () -> Void
    private var offsetObserver: NSKeyValueObservation?
    
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()
        
        offsetObserver = tableView.observe(\.contentOffset, options: .new) { [weak self] (tableView, _) in
            guard tableView.isDragging else { return }
            
            self?.reloadIfNeeded()
        }
    }
    
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        offsetObserver = nil
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }
    
    
    private func reloadIfNeeded() {
        guard !cell.isLoading else { return }
        
        callback()
    }
} */
