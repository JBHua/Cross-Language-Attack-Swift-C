// https://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift
struct MemoryAddress<T>: CustomStringConvertible {

    let intValue: Int
    var inputVal: T

    var description: String {
        let length = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
        return String(format: "%0\(length)p", intValue)
    }

    // for structures
    init(of structPointer: UnsafePointer<T>) {
        intValue = Int(bitPattern: structPointer)
        inputVal = structPointer.pointee
    }
}

extension MemoryAddress where T: AnyObject {

    // for classes
    init(of classInstance: T) {
        intValue = unsafeBitCast(classInstance, to: Int.self)
        inputVal = classInstance
        // or      Int(bitPattern: Unmanaged<T>.passUnretained(classInstance).toOpaque())
    }
}

typealias emptyIemptyO = @convention(thin) () -> ()
typealias inoutIntIemptyO = @convention(thin) (inout Int) -> ()

func getFuncAddr(_ function: @escaping emptyIemptyO) -> UnsafeMutableRawPointer {
    return unsafeBitCast(function, to: UnsafeMutableRawPointer.self)
}

func getFuncAddrInt(_ function: @escaping emptyIemptyO) -> Int {
    return unsafeBitCast(function, to: Int.self)
}

func getFuncAddrInt(_ function: @escaping inoutIntIemptyO) -> Int {
    return unsafeBitCast(function, to: Int.self)
}
