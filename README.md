# Reachability

A new, clean and lean network interface reachability library written in Swift.

## Remarks

Network reachability changes can be monitored using the built-in Combine publisher or an async stream.

While it is possible to create customised instances, a default `shared` instance is provided.

The native `NWPathMonitor` is used under the covers to provide the library functionality.

## Basic Usage

### Simple

```swift
import Reachability

if Reachability.shared.currentPath.isReachable {
    print("We are online")
} else {
    print("No internet")
}

```


### Using Combine

```swift
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

While in Xcode, go to *File / Swift Packages / Add Package Dependency…* and enter the package repository URL `https://github.com/Alecrim/Reachability.git`, then follow the instructions.

To remove the dependency, select the project and open *Swift Packages* (next to *Build Settings*).

## Minimum Requirements

| Reachability     | Swift     | Xcode      | Platforms                                        |
| ---------------- | --------- | ---------- | ------------------------------------------------ |
| Reachability 1.0 | Swift 5.5 | Xcode 13.0 | macOS 10.15 / iOS 13.0 / tvOS 13.0 / watchOS 6.0 |

## License

**Reachability** is available under the MIT license. See the LICENSE file for more info.
