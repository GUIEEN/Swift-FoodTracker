//
//  Meal.swift
//  FoodTracker
//
//  Created by GUIEEN on 5/8/19.
//  Copyright © 2019 GUIEEN. All rights reserved.
//

import UIKit
import os.log


// 1. To be able to encode and decode itself and its properties, the Meal class needs to conform to the NSCoding protocol.
// 2. To conform to NSCoding, the Meal needs to subclass NSObject.
// 3. NSObject is considered a base class that defines a basic interface to the runtime system.
// NSCoding -> NSObject
class Meal:  NSObject, NSCoding {

    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int

    
    //MARK: Archiving Paths
    //  DocumentsDirectory constant uses the file manager’s urls(for:in:) method to look up the URL for your app’s documents directory. This is a directory where your app can save data for the user. This method returns an array of URLs, and the first parameter returns an optional containing the first URL in the array. However, as long as the enumerations are correct, the returned array should always contain exactly one match. Therefore, it’s safe to force unwrap the optional.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals") // Here, you create the file URL by appending meals to the end of the documents URL.
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        
//        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0  {
//            return nil
//        }
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // `required` modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
    // `convenience` modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
    // The question mark (?) means that this is a failable initializer that might return nil.
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        // If the downcast fails, it assigns nil to the photo property. There is no need for a guard statement here, because the photo property is itself an optional.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
        
    }
    
}
