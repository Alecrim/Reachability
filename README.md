# ``Reachability``
A new, clean and simple network interface reachability library written in Swift.

## Overview
Network reachability changes can be monitored using the built-in Combine publisher or an async stream.

While it is possible to create customized instances, a default `shared` instance is provided.

Please note that the native [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor) is used under the covers to provide the library functionality.

## Usage
### Basic
```swift
import Reachability

if Reachability.shared.currentPath.isReachable {
    print("We are online")
} else {
    print("No internet")
}
```

### Using with SwiftUI
```swift
import Reachability
import SwiftUI

struct SomeView: View {
    @ObservedObject var reachability = Reachability.shared

    var body: some View {
        if reachability.currentPath.isReachable {
            // Show some data loaded from the internet
        } else {
            Text("No internet connection")
        }
    }
}
```

### Using with Combine
```swift
import Combine
import Reachability

var subscriptions = Set<AnyCancellable>()

Reachability.shared.publisher
    .sink { path in
        if path.isReachable {
            print("We are online")
        } else {
            print("No internet")
        }
    }
    .store(in: &subscriptions)
```

### Using AsyncStream
```swift
import Reachability

Task {
    for await path in Reachability.shared.stream {
        if path.isReachable {
            print("We are online")
        } else {
            print("No internet")
        }
    }
}
```

## Installation
**Reachability** can be installed using [Swift Package Manager](https://swift.org/package-manager/), a dependency manager built into Xcode.

While in Xcode, go to the menu *File → Swift Packages → Add Package Dependency…* and enter the package repository URL `https://github.com/Alecrim/Reachability.git`, then follow the instructions.

To remove the dependency, select the project and open *Swift Packages* (next to *Build Settings*).

## Minimum Requirements

| Reachability | Swift | Xcode | Platforms                                             |
|--------------|-------|-------|-------------------------------------------------------|
| 1.x          | 5.5   | 13.0  | macOS 10.15 (Catalina), iOS 13, tvOS 13 and watchOS 6 |

## Inspiration
[Reachability](https://github.com/tonymillion/Reachability) and [Reachability.swift](https://github.com/ashleymills/Reachability.swift)

## License
**Reachability** is available under the MIT license. See the LICENSE file for more info.
