//
//  FDMGcdTimer.swift
//
//  Created by 发抖喵 on 2020/5/7.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMGcdTimer: NSObject {
    
    var gcdTimer: DispatchSourceTimer?
    var timeCount: Int = 0
    
    /**
     创建
     */
    func createTimer(deadline: DispatchTime = .now(), repeating: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .seconds(0), calltime: Int = 1 , endOfTime:@escaping (Int) -> (), timeInProgress timeElse:@escaping (Int) -> ()) {
        
        gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        gcdTimer?.schedule(deadline: deadline, repeating: repeating, leeway: leeway)
        gcdTimer?.setEventHandler(handler: { [weak self] in
            if self!.timeCount <= 0{
                endOfTime(self!.timeCount)
            }else{
                timeElse(self!.timeCount)
                self!.timeCount -= calltime
            }
        })
    }
    
    /**
     启动
     */
    func resume() {
        gcdTimer?.resume()
    }
    
    /**
     暂停
     */
    func suspend() {
        gcdTimer?.suspend()
    }
    
    /**
     销毁
     */
    func cancel() {
        gcdTimer?.cancel()
        
        if gcdTimer != nil {
            gcdTimer = nil
        }
    }
}
