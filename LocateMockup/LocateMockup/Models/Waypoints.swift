//
//  Waypoints.swift
//  LocateMockup
//
//  Created by dEEEP on 25/04/18.
//  Copyright © 2018 vannteqfarm. All rights reserved.
//



import Foundation
import CoreLocation


enum WaypointsAttributes :String {
  case
  id = "id",
  waypointAddress = "waypointAddress",
  waypointLocation = "waypointLocation",
  identifier = "identifier",
  waypointMainInstruction = "waypointMainInstruction",
  waypointSubInstruction = "waypointSubInstruction",
  pointRecieverName = "pointRecieverName",
  delivery = "delivery",
  pointReceiverPhone = "pointReceiverPhone",
  step_index = "step_index"
 
  
  
  
  
  
  static let getAll = [
    id,
    waypointAddress,
    waypointLocation,
    identifier,
    waypointMainInstruction,
    waypointSubInstruction,
    delivery,
    pointRecieverName,
    pointReceiverPhone,
    step_index
  ]
}

public class Waypoints {
  public var id : Int?
  public var waypointAddress : String?
  public var waypointLocation : CLLocationCoordinate2D?
  public var identifier : String?
  public var waypointMainInstruction : String?
  public var waypointSubInstruction : String?
  public var delivery : Delivery?
  public var pointRecieverName : String?
  public var pointReceiverPhone : String?
  public var step_index : Int?
  
  
  /**
   Returns an array of models based on given dictionary.
   
   Sample usage:
   let Waypoints_list = Waypoints.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
   
   - parameter array:  NSArray from JSON dictionary.
   
   - returns: Array of Waypoints Instances.
   */
  public class func modelsFromDictionaryArray(array:NSArray) -> [Waypoints]
  {
    var models:[Waypoints] = []
    for item in array
    {
      models.append(Waypoints(dictionary: item as! NSDictionary)!)
    }
    return models
  }
  
  /**
   Constructs the object based on the given dictionary.
   
   Sample usage:
   let Waypoints = Waypoints(someDictionaryFromJSON)
   
   - parameter dictionary:  NSDictionary from JSON.
   
   - returns: Waypoints Instance.
   */
  public init?(dictionary: NSDictionary) {
    
    id = dictionary["id"] as? Int
    waypointAddress = dictionary["waypointAddress"] as? String
    waypointLocation = dictionary["waypointLocation"] as? CLLocationCoordinate2D
    identifier = dictionary["identifier"] as? String
    waypointMainInstruction = dictionary["waypointMainInstruction"] as? String
    waypointSubInstruction = dictionary["waypointSubInstruction"] as? String
    delivery = dictionary["delivery"] as? Delivery
    pointRecieverName = dictionary["pointRecieverName"] as? String
    pointReceiverPhone = dictionary["pointReceiverPhone"] as? String
    step_index = dictionary["step_index"] as? Int
  }
  
  
  
  init(waypointLocation: CLLocationCoordinate2D, identifier: String, pointRecieverName: String, pointReceiverPhone: String, waypointMainInstruction: String, waypointSubInstruction: String,delivery:Delivery) {
    self.waypointLocation = waypointLocation
    self.identifier = identifier
    self.pointRecieverName = pointRecieverName
    self.pointReceiverPhone = pointReceiverPhone
    self.waypointMainInstruction = waypointMainInstruction
    self.waypointSubInstruction = waypointSubInstruction
    self.delivery = delivery
  }
  
  
  
  
  
  
  /**
   Returns the dictionary representation for the current instance.
   
   - returns: NSDictionary.
   */
  public func dictionaryRepresentation() -> NSDictionary {
    
    let dictionary = NSMutableDictionary()
    
    dictionary.setValue(self.id, forKey: "id")
    dictionary.setValue(self.waypointAddress, forKey: "waypointAddress")
    dictionary.setValue(self.waypointLocation, forKey: "waypointLocation")
    dictionary.setValue(self.identifier, forKey: "identifier")
    dictionary.setValue(self.waypointMainInstruction, forKey: "waypointMainInstruction")
    dictionary.setValue(self.waypointSubInstruction, forKey: "waypointSubInstruction")
    dictionary.setValue(self.delivery, forKey:"delivery")
    dictionary.setValue(self.pointRecieverName, forKey:"pointRecieverName")
    dictionary.setValue(self.pointReceiverPhone, forKey: "pointReceiverPhone")
    dictionary.setValue(self.step_index, forKey: "step_index")
    return dictionary
  }
  
}

