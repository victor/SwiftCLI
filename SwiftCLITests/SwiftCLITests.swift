//
//  SwiftCLITests.swift
//  SwiftCLITests
//
//  Created by Jake Heiser on 8/2/14.
//  Copyright (c) 2014 jakeheis. All rights reserved.
//

import Cocoa
import XCTest

class SwiftCLITests: XCTestCase {
    
    var silentFlag = false
    var times: Int = 1
    var executionString = ""
    
    override func setUp() {
        super.setUp()
        
        CLI.setup(name: "tester")
        CLI.registerChainableCommand(commandName: "test")
            .withSignature("<testName> [<testerName>]")
            .withFlagsHandled(["-s"], block: {(flag) in
                self.silentFlag = true
            }, usage: "Silent flag")
            .withKeysHandled(["-t"], block: {(key, value) in
                self.times = value.toInt()!
            }, usage: "Times to test", valueSignature: "times")
            .withExecutionBlock {(arguments, options) in
                let testerName = arguments["testerName"] as String? ?? "Tester"
                let testName = arguments["testName"] as String
                self.executionString = "\(testerName) will test \(testName), \(self.times) times"
                if self.silentFlag {
                    self.executionString += ", silently"
                }
                return .Success
            }
    }
    
    // Integration test
    
    func testCLIGo() {
        let result = CLI.debugGoWithArgumentString("tester test firstTest MyTester -t 5 -s")
        XCTAssertEqual(result, CLIResult.Success, "Command should have succeeded")
        XCTAssertEqual(self.executionString, "MyTester will test firstTest, 5 times, silently", "Command should have produced accurate output")
    }
    
    // Tear down
    
    override func tearDown() {
        super.tearDown()
        
        executionString = ""
    }
    
}
