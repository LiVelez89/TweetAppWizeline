//
//  QueueSchedulerProtocol.swift
//  TweetAppWizeline
//
//  Created by Lina on 29/05/23.
//

import Foundation

protocol QueueScheduler {
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    )
}

extension QueueScheduler {
    func async(
        execute work: @escaping @convention(block) () -> Void
    ) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

extension DispatchQueue: QueueScheduler {}
