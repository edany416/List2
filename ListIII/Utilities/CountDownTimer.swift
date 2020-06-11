//
//  CountDownTimer.swift
//  ListIII
//
//  Created by Edan on 6/10/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol CountDownTimerDelegate: class {
    func countDownDidFinish()
}
class CountDownTimer {
    private  var timer: Timer!
    private var countdownTime: TimeInterval
    private var elapsedTime: TimeInterval
    
    weak var delegate: CountDownTimerDelegate?
    
    init(countingDownFrom countdownTime: TimeInterval) {
        self.countdownTime = countdownTime
        elapsedTime = 0
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
        elapsedTime = 0
    }
    
    @objc private func timerFired() {
        update()
    }
    
    private func update() {
        elapsedTime += 1
        if countdownTime - elapsedTime <= 0 {
            delegate?.countDownDidFinish()
            timer.invalidate()
            elapsedTime = 0
        }
    }
}
