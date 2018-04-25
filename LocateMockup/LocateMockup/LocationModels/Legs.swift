/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Legs {
	public var distance : Distance?
	public var duration : Duration?
	public var end_address : String?
	public var end_location : End_location?
	public var start_address : String?
	public var start_location : Start_location?
	public var steps : Array<Steps>?
	public var traffic_speed_entry : Array<String>?
	public var via_waypoint : Array<Via_waypoint>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let legs_list = Legs.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Legs Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Legs]
    {
        var models:[Legs] = []
        for item in array
        {
            models.append(Legs(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let legs = Legs(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Legs Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["distance"] != nil) { distance = Distance(dictionary: dictionary["distance"] as! NSDictionary) }
		if (dictionary["duration"] != nil) { duration = Duration(dictionary: dictionary["duration"] as! NSDictionary) }
		end_address = dictionary["end_address"] as? String
		if (dictionary["end_location"] != nil) { end_location = End_location(dictionary: dictionary["end_location"] as! NSDictionary) }
		start_address = dictionary["start_address"] as? String
		if (dictionary["start_location"] != nil) { start_location = Start_location(dictionary: dictionary["start_location"] as! NSDictionary) }
		if (dictionary["steps"] != nil) { steps = Steps.modelsFromDictionaryArray(array: dictionary["steps"] as! NSArray) }
//		if (dictionary["traffic_speed_entry"] != nil) { traffic_speed_entry = traffic_speed_entry.modelsFromDictionaryArray(dictionary["traffic_speed_entry"] as! NSArray) }
		if (dictionary["via_waypoint"] != nil) { via_waypoint = Via_waypoint.modelsFromDictionaryArray(array: dictionary["via_waypoint"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.distance?.dictionaryRepresentation(), forKey: "distance")
		dictionary.setValue(self.duration?.dictionaryRepresentation(), forKey: "duration")
		dictionary.setValue(self.end_address, forKey: "end_address")
		dictionary.setValue(self.end_location?.dictionaryRepresentation(), forKey: "end_location")
		dictionary.setValue(self.start_address, forKey: "start_address")
		dictionary.setValue(self.start_location?.dictionaryRepresentation(), forKey: "start_location")

		return dictionary
	}

}
