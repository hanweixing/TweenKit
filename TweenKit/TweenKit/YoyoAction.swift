//
//  YoyoAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class YoyoAction: FiniteTimeAction {
    
    // MARK: - Types
    
    enum State {
        case idle
        case forwards
        case backwards
    }
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    public var reverse = false {
        didSet{
            if reverse != oldValue {
                action.reverse = !action.reverse
            }
        }
    }

    public init(action: FiniteTimeAction) {
        
        self.action = action
        self.duration = action.duration * 2
    }
    
    // MARK: - Private Properties
    
    public internal(set) var duration: Double
    let action: FiniteTimeAction
    var state = State.idle
    
    // MARK: - Private Methods
    
    public func willBecomeActive() {
        onBecomeActive()
        action.willBecomeActive()
    }

    public func didBecomeInactive() {
        onBecomeInactive()
        action.didBecomeInactive()
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
        action.didFinish()
        state = .idle
    }
    
    public func update(t: CFTimeInterval) {
        
        /*
         The order of state changes and setReverse is important here. The inner action should receive the following calls:
         
         - will begin
         - will finish
         - reverse = true
         - will begin
         - will finish
 
         Now the action is 'invoked twice' (two begin/finish calls), and it has the correct reverse state at the time of each call
         There are unit tests that test the call order, please run them after making changes
         */
        
        if t < 0.5 {
            
            if state == .idle {
                action.reverse = reverse
                action.willBegin()
            }
            else if state == .backwards {
                action.didFinish()
                action.reverse = reverse
                action.willBegin()
            }
            
            let actionT = t * 2
            action.update(t: actionT)
            
            state = .forwards
        }
        else{
            
            if state == .idle {
                action.reverse = !reverse
                action.willBegin()
            }
            else if state == .forwards {
                action.didFinish()
                action.reverse = !reverse
                action.willBegin()
            }

            let actionT = 1-((t - 0.5) * 2);
            action.update(t: actionT)
            
            state = .backwards
        }
    }
}

public extension FiniteTimeAction {
    
    public func yoyo() -> YoyoAction {
        return YoyoAction(action: self)
    }
}