//
//  main.swift
//  XibMaster
//
//  Created by Genady Novak on 1/19/17.
//  Copyright © 2017 Gena. All rights reserved.
//

import Foundation


func testXibs() -> Bool{
    var success = true
    if CommandLine.arguments.count > 1{
        let path = CommandLine.arguments[1]
        
        let fileManager = FileManager.default
        let enumerator : FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path)!
        var xibContent = ""
        var testResault = true
        var filesPathsWithError : [String] = []
        var fullPath = ""
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(".xib") {
                fullPath = "\(path)/\(element)"
                xibContent = readFile(fromPath: fullPath)
                testResault = test(xibContent: xibContent)
                if testResault == false{
                    filesPathsWithError.append(fullPath)
                }
            }
        }
        
        success = filesPathsWithError.count == 0
        
        if success == false{
            writeErrors(filesPathsWithError: filesPathsWithError)
        }
        
        
    }
    
    
    
    return success
}

func test(xibContent xib : String) -> Bool{
    if (xib.contains("\"leading\"") ||
        xib.contains("\"trailing\"") ||
        xib.contains("\"leadingMargin\"") ||
        xib.contains("\"trailingMargin\"")){
        return false
    }
    else{
        return true
    }
    
}

func writeErrors(filesPathsWithError errors : [String]){
    if CommandLine.arguments.count > 2{
        let outputName = "errors.txt"
        let outputPath = CommandLine.arguments[2]
        let fullPath = "\(outputPath)/\(outputName)"
        
        let errorText = errors.joined(separator: "\n")
        do {
            try errorText.write(toFile: fullPath, atomically: false, encoding: .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        
    }
    
}


func readFile(fromPath path : String) -> String {
    var textToReturn = ""
    
    let url : URL = URL(fileURLWithPath: path)
    do{
        textToReturn = try String(contentsOf: url, encoding: .utf8)
    }
    catch{
        print(error.localizedDescription)
    }
    
    
    
    return textToReturn
    
}


print(testXibs())


