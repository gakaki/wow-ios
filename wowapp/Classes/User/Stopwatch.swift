import Foundation
import QuartzCore

/// Calculates elapsed time.
///
/// Typical usage is to construct an instance at the start of an operation,
/// and then call `elapsedTimeInterval()` or `elapsedTimeString()` at
/// the end to determine how much time has passed.
///
/// The underlying time reference is `mach_absolute_time()`

public struct Stopwatch {
    private var startTime: NSTimeInterval
    
    /// Initialize with current time as start point.
    public init() {
        startTime = CACurrentMediaTime()
    }
    
    /// Reset start point to current time
    public mutating func reset() {
        startTime = CACurrentMediaTime()
    }
    
    /// Calculate elapsed time since initialization or last call to `reset()`.
    ///
    /// - returns: `NSTimeInterval`
    public func elapsedTimeInterval() -> NSTimeInterval {
        return CACurrentMediaTime() - startTime
    }
    
    /// Get elapsed time in textual form.
    ///
    /// If elapsed time is less than a second, it will be rendered as milliseconds.
    /// Otherwise it will be rendered as seconds.
    ///
    /// - returns: `String`
    public func elapsedTimeString() -> String {
        let interval = elapsedTimeInterval()
        if interval < 1.0 {
            return NSString(format:"%.1f ms", Double(interval * 1000)) as String
        }
        else {
            return NSString(format:"%.2f s", Double(interval)) as String
        }
    }
}

extension Stopwatch: CustomStringConvertible {
    public var description: String {
        return elapsedTimeString()
    }
}