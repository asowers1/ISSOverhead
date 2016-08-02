//
//  Scheduler.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation

public typealias Task = (() -> Void)
public protocol Scheduler {
    func scheduleTask(task: Task, delay: NSTimeInterval) -> ScheduledTaskType
}

public protocol ScheduledTaskType {
    func cancel()
}

public class ScheduledTask: NSObject, ScheduledTaskType {
    var timer: NSTimer!
    let task: Task
    
    init(task: Task, delay: NSTimeInterval) {
        self.task = task
        super.init()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(ScheduledTask.performTask(_:)), userInfo: nil, repeats: false)
    }
    
    func performTask(timer: NSTimer) {
        self.task()
    }
    
    public func cancel() {
        if self.timer.valid {
            self.timer.invalidate()
        }
    }
}

public class TaskScheduler: Scheduler {
    public func scheduleTask(task: Task, delay: NSTimeInterval) -> ScheduledTaskType {
        return ScheduledTask(task: task, delay: delay)
    }
}