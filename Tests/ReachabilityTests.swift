import XCTest
@testable import Reachability

import Combine

final class ReachabilityTests: XCTestCase {
    fileprivate private(set) lazy var subscriptions = Set<AnyCancellable>()
}

extension ReachabilityTests {
    func testPublisherValue() {
        let expectation = expectation(description: "Value")
        var isExpectationFulfilled = false

        Reachability.shared.publisher
            .sink { _ in
                //
            } receiveValue: { path in
                if isExpectationFulfilled {
                    XCTFail("Expectation fulfilled more than once")
                }
                else {
                    isExpectationFulfilled = true
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 10)
    }

    func testPublisherCompletion() {
        let expectation = expectation(description: "Completion")

        Reachability().publisher
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { _ in
                //
            }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 10)
    }
}

extension ReachabilityTests {
    func testStreamValue() async {
        let expectation = expectation(description: "Value")

        for await _ in Reachability.shared.stream {
            expectation.fulfill()
            break
        }

        await waitForExpectations(timeout: 10)
    }

    func testStreamCompletion() async {
        let expectation = expectation(description: "Completion")

        for await _ in Reachability().stream {
            break
        }

        expectation.fulfill()

        await waitForExpectations(timeout: 10)
    }
}
