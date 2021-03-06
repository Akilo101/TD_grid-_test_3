//
// GOOD ONE
//  Extensions.swift
//  Cookie Crunch
//
//  Created by jeremy on 3/7/16.
//  Copyright © 2016 Indicane. All rights reserved.
//

//Loads JSON Files

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            
            do{
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMapped)
                do{
                    let dictionary: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions())
                    if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                        return dictionary
                    } else {
                        print("Level file '\(filename)' is not valid JSON")
                        return nil
                    }
                }catch {
                    print("Level file '\(filename)' is not valid JSON: \(error)")
                    return nil
                }
                
                
            }catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
}