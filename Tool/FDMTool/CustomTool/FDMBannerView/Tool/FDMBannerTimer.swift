//
//  FDMGcdTimer.swift
//
//  Created by 发抖喵 on 2020/5/7.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMBannerTimer: NSObject {
    
    /// gcd
    var gcdTimer: DispatchSourceTimer?
    
    /// 持续时间
    var timeCount: Int = 0
    
    /// 首次启动
    var firstStart = false
    
    /// 暂停状态
    var suspendStatus = false
    
    /**
     创建定时器 - 注： 设置 TimeCount = 0
     
     - parameter deadline: 开始时间
     - parameter repeating: 重复时间
     - parameter leeway: 允许最大误差
     - parameter calltime: 每次回调后减少的时间
     - parameter endOfTime: 定时器即将结束回调
     - parameter calltime: 定时器每打到规定时间回调
     */
    func createTimer(deadline: DispatchTime = .now(), repeating: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .seconds(0), calltime: Int = 1 , endOfTime: ((Int) -> ())?, timeInProgress timeElse: ((Int) -> ())?) {
        guard gcdTimer == nil else { return }
        
        gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        gcdTimer?.schedule(deadline: deadline, repeating: repeating, leeway: leeway)
        gcdTimer?.setEventHandler(handler: { [weak self] in
            if self?.timeCount ?? 0 <= 0{
                endOfTime?(self?.timeCount ?? 0)
            }else{
                timeElse?(self?.timeCount ?? 0)
                self?.timeCount -= calltime
            }
        })
    }
    
    /**
     启动
     */
    func resume() {
        if !firstStart {
            firstStart = true
            gcdTimer?.resume()
            
        }else if suspendStatus {
            suspendStatus = false
            gcdTimer?.resume()
        }
        
    }
    
    /**
     暂停
     */
    func suspend() {
        if suspendStatus { return }
        
        suspendStatus = true
        gcdTimer?.suspend()
    }
    
    /**
     销毁
     */
    func cancel() {
        gcdTimer?.cancel()
        
        firstStart = false
        suspendStatus = false
        gcdTimer = nil
    }
}
