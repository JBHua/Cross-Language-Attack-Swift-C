// Original Unsafe Library should be imported as: MyLibraryCUnsafe
// import MyLibraryCUnsafe

// Sandboxed Safe Library should be imported as: MyLibraryCSafe
// This is the default option. Notice the API Change due to WASM Sandboxing
import MyLibraryCSafe
import Foundation

@_cdecl("get_attack")
func get_attack() -> Int {
    return getFuncAddrInt(attack)
}

let MAX_CAPACITY = 3

struct CustomData {
    var vals = NSMutableArray(capacity: MAX_CAPACITY)
    var cb: Int // Experiemental purpose only
    var slice: Array<Int> //NSMutableArray
    var cb2: Int // Experiemental purpose only
}

func doubler(x: inout Int) {
    print("Not attacked! Adding two to the input...")
    x = x + 2
}

func incrementer(x: inout Int) {
    print("Not attacked! Adding one to the input...")
    x = x + 1
}

func attack() {
    print("We were attacked!")
}

func AnalyzeData(_ cbFptr: inout (inout Int) -> ()) {
    MyLibraryCSafe.wasmbox_init()
    
    let fa1 = incrementer
    let fp1 = getFuncAddrInt(fa1)
    // print("[Swift AnalyzeData] fp1: \(fp1)")
    
    var fa2 = doubler
    let fp2 = MemoryAddress(of: &fa2).intValue
    // let fp2 = getFuncAddrInt(fa2)//MemoryAddress(of: &fa2)
    // print("[Swift AnalyzeData] fp2: \(fp2)")

    var data = CustomData(
        vals: NSMutableArray(array: [1, 2, 3]), 
        cb: fp1,
        slice: [89, 64], //(array: [3, 5], capacity),  
        cb2: fp2)

    print("\n")
    // print("[Swift AnalyzeData] vals addr:  \(MemoryAddress(of: &data.vals).intValue)")   //
    // print("[Swift AnalyzeData] cb addr:    \(MemoryAddress(of: &data.cb).intValue)")     // + 8
    // let dataSliceAddr = MemoryAddress(of: &data.slice).intValue
    // print("[Swift AnalyzeData] slice addr: \(dataSliceAddr)")  // + 16, 
    // print("[Swift AnalyzeData] cb2 addr:   \(MemoryAddress(of: &data.cb2).intValue)")    // + 8

    // print("[Swift AnalyzeData] program arg fp0 on stack: \(MemoryAddress(of: &cbFptr))")
    
    // let doublerFp = UnsafeMutablePointer<(inout Int) -> ()>.allocate(capacity: 8)
    // doublerFp.initialize(from: fp2, count: 1)
    // print("[Swift AnalyzeData] Heap alloc 1: doublerFp: \(MemoryAddress(of: doublerFp))")

    // let doubler2Fp = UnsafeMutablePointer<(inout Int) -> ()>.allocate(capacity: 8)
    // doubler2Fp.initialize(from: fa2, count: 1)
    // print("[Swift AnalyzeData] Heap alloc 2: doubler2Fp: \(MemoryAddress(of: doubler2Fp))")
	
	// MARK: - Section 4 Attacks
	// MARK: Get a callback function pointer from C (Data Corruption cross FFI boundary)
    // After Sandboxing: Result: Segfault
    // let incrementerFpAddrFromC = MyLibraryCSafe.Z_get_cb_from_cZ_jv()
    // print("[Swift AnalyzeData] ", incrementerFpAddrFromC)
    // let incrementerFunc = unsafeBitCast(incrementerFpAddrFromC, to: inoutIntIemptyO.self)
	// print("[Swift AnalyzeData] [Attack 0]")
    // print("[Swift AnalyzeData] Got a callback function in C: \(String(describing: incrementerFunc))")
	// var dummy1 = 1
	// incrementerFunc(&dummy1)

    // MARK: 2. Swift Static Bounds Check Bypass Attack (OOB)
    // After SandboxingResult: [wasm trap 1, halting]
    //                         Aborted
    // print("[Swift AnalyzeData] [Attack 1] Launching Swift Static Bounds Check Bypass Attack")
    // MyLibraryCSafe.Z_user_given_arrayZ_vj(UInt64(MemoryAddress(of: &(data.vals)).intValue))
    // print("[Swift AnalyzeData] Calling data.cb...")
    // print("[Swift AnalyzeData] Modified data.cb val: \(data.cb)")
    // // FIXME: This is where we calls the malicious/modified func ptr
    // let dataCBFuncPtr = unsafeBitCast(data.cb, to: inoutIntIemptyO.self)
    // var dummy2 = 1
    // dataCBFuncPtr(&dummy2)
    
    // MARK: 3. Swift ARC Attack, Double Free
    // After SandboxingResult: [wasm trap 1, halting]
    //                         Aborted
	//  https://developer.apple.com/documentation/swift/unsafemutablepointer/allocate(capacity:)
	// print("[Swift AnalyzeData] Allocating heap memory for Integer Array")
	// let heapAllocated = UnsafeMutablePointer<Int>.allocate(capacity: 5)
	// for i in 0..<5 {
	// 	(heapAllocated + i).initialize(to: i)
	// }
	// MyLibraryCSafe.print_array_addr(Int64(MemoryAddress(of: heapAllocated).intValue))
	// print("[Swift AnalyzeData] This should print 0:", (heapAllocated.pointee + 5))

	
    // MARK: 4. Corrupting Swift Dynamic Bounds
    // MARK: Slices in Go and Array Swift are quite different
    // NOTE: After days of investgation, it turns out to be impossible to 
    // recreate this attack in Swift due to the internal implementation of
    // Swift Array
    // http://ankit.im/swift/2016/01/07/exploring-swift-array-implementation/
    // https://github.com/apple/swift/blob/5480577e6713aa0a545f83ca92816c0b950918c7/stdlib/public/core/ContiguousArrayBuffer.swift
    // https://github.com/apple/swift/blob/main/stdlib/public/core/Array.swift
}

func main() {
    print("\n---------------------")

    var fa0: (inout Int) -> () = incrementer
    AnalyzeData(&fa0)
}

main()
