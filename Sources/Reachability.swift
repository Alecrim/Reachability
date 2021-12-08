//
//  Reachability.swift
//
//  Created by Vanderlei Martinelli on 19/02/20.
//  Copyright © 2020 Vanderlei Martinelli. All rights reserved.
//

import Foundation
import Combine
import Network

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class Reachability: ObservableObject {
    public static let shared = Reachability()

    @Published public private(set) var currentPath: NWPath

    public private(set) lazy var publisher = makePublisher()
    public private(set) lazy var stream = makeStream()

    private let monitor: NWPathMonitor
    private lazy var subject = CurrentValueSubject<NWPath, Never>(monitor.currentPath)
    private var subscription: AnyCancellable?

    public init(requiredInterfaceType: NWInterface.InterfaceType? = nil, prohibitedInterfaceTypes: [NWInterface.InterfaceType]? = nil, queue: DispatchQueue = .main) {
        precondition(!(requiredInterfaceType != nil && prohibitedInterfaceTypes != nil), "Parameter combination not supported")

        if let requiredInterfaceType = requiredInterfaceType {
            monitor = NWPathMonitor(requiredInterfaceType: requiredInterfaceType)
        }
        else if let prohibitedInterfaceTypes = prohibitedInterfaceTypes {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                monitor = NWPathMonitor(prohibitedInterfaceTypes: prohibitedInterfaceTypes)
            }
            else {
                preconditionFailure("Feature not supported in this OS version")
            }
        }
        else {
            monitor = NWPathMonitor()
        }

        currentPath = monitor.currentPath

        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentPath = path
            self?.subject.send(path)
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
        subject.send(completion: .finished)
    }

    private func makePublisher() -> AnyPublisher<NWPath, Never> {
        return subject.eraseToAnyPublisher()
    }

    private func makeStream() -> AsyncStream<NWPath> {
        return AsyncStream { continuation in
            var subscription: AnyCancellable?

            subscription = subject.sink { _ in
                continuation.finish()
            } receiveValue: { value in
                continuation.yield(value)
            }

            self.subscription = subscription
        }
    }
}

extension NWPath {
    public var isReachable: Bool { status == .satisfied }
}
