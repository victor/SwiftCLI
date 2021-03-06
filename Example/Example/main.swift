//
//  main.swift
//  Example
//
//  Created by Jake Heiser on 7/31/14.
//  Copyright (c) 2014 jakeheis. All rights reserved.
//

import Foundation

CLI.setup(name: "baker", description: "Baker - your own personal baker, here to bake you whatever you desire.")

CLI.registerChainableCommand(commandName: "init")
    .withShortDescription("Creates a Bakefile in the current or given directory")
    .withSignature("[<directory>]")
    .withExecutionBlock({arguments, options in
        let givenDirectory = arguments["directory"] as String?
        
        let fileName = givenDirectory?.stringByAppendingPathComponent("Bakefile") ?? "./Bakefile"
        
        let dict = ["items": []]
        let success = NSFileManager.defaultManager().createFileAtPath(fileName, contents: NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted, error: nil), attributes: nil)
        if success {
            return .Success
        } else {
            return .Failure("The Bakefile was not able to be created")
        }
    })


let listCommand = LightweightCommand(commandName: "list")
listCommand.lightweightCommandShortDescription = "Lists some possible items the baker can bake for you."

var showExoticFoods = false
listCommand.handleFlags(["-e", "--exotics-included"], block: {flag in
    showExoticFoods = true
}, usage: "Include exotic foods in the list of items baker can bake you")

listCommand.lightweightExecutionBlock = {arguments, options in
    var foods = ["bread", "cookies", "cake"]
    if showExoticFoods {
        foods += ["exotic baker item 1", "exotic baker item 2"]
    }
    println("Items that baker can bake for you:")
    for i in 0..<foods.count {
        println("\(i+1). \(foods[i])")
    }
    return .Success
}
CLI.registerCommand(listCommand)

let bakerCommand = BakeCommand()
CLI.registerCommand(bakerCommand)

let recipeCommand = RecipeCommand()
CLI.registerCommand(recipeCommand)

let result = CLI.go()
exit(result)
