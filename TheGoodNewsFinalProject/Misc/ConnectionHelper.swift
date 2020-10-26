//
//  ConnectionHelper.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 26/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Network

class ConnectionHelper {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "ConnectionMonitor")

    func connected(completion:@escaping(Bool)->Void) {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
                completion(true)
            } else {
                print("There's no internet connection.")
                completion(false)
            }
        }

        monitor.start(queue: queue)
    }
}
