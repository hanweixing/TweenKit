//
//  RepeatForeverAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Repeats inner action forever */
public class RepeatForeverAction: InfiniteTimeAction {

    // MARK: - Public

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    /**
     Create with an action to repeat forever
     - Parameter action: The action to repeat
     */
    public init(action: FiniteTimeAction) {
        self.action = action;
    }
    
    // MARK: - Private Properties
    let action: FiniteTimeAction
    var lastRepeatNumber: Int = 0

    // MARK: - Private Methods
    
    public func willBecomeActive() {
        onBecomeActive()
        action.willBecomeActive()
    }
    
    public func didBecomeInactive() {
        action.didBecomeInactive()
        onBecomeInactive()
    }
    
    public func willBegin() {
        action.willBegin()
    }
    
    public func didFinish() {
        action.didFinish()
    }
    
    public func update(elapsedTime: CFTimeInterval) {
        guard action.duration != 0 else {
            self.action.didFinish()
            self.action.willBegin()
            return
        } 
        let repeatNumber = Int(elapsedTime / action.duration)
        
        (lastRepeatNumber..<repeatNumber).forEach{ [weak self] _ in
            self?.action.didFinish()
            self?.action.willBegin()
        }

        let actionT = (elapsedTime / action.duration).fract
        action.update(t: actionT)
        
        lastRepeatNumber = repeatNumber
    }
}

public extension FiniteTimeAction {
    
    func repeatedForever() -> RepeatForeverAction {
        return RepeatForeverAction(action: self)
    }
}
