// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package( 
    name: "CLA-Swift", 
	products: [
		.executable(
			name: "CLA-Swift", 
			targets: [
				"CLA-Swift-exe"
			] 
		)
	],
    targets: [
		.systemLibrary(name: "MyLibraryCSafe", path: "./Sources/CLA-Swift-exe"),
		.executableTarget(
			name: "CLA-Swift-exe",
			dependencies: [
				"MyLibraryCSafe"
			]
		)
    ]
)
