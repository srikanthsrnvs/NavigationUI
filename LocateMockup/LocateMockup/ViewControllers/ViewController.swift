//
//  ViewController.swift
//  LocateMockup
//
//  Created by dEEEP on 20/04/18.
//  Copyright © 2018 vannteqfarm. All rights reserved.
//

import UIKit
import GoogleMaps


struct Constants {
struct googleMaps {
  static let Key = "AIzaSyCYvIjN36FvpHSfgFk83kq2N-i1VKviTDQ"
}
}

class ViewController: UIViewController {

  //UIOutlets
  @IBOutlet weak var gMap: GMSMapView!
  @IBOutlet weak var mActionBtn: UIButton!
  @IBOutlet weak var mDirectionTableView: UITableView!
  @IBOutlet weak var mSearchView: UIView!
  var myWayPoints: [Waypoints]!
  
  var vcHelper:VCHelper!
  var txtToSpeech :TextToSpeech!
  var font1:UIFont!
  var font2:UIFont!
  
  //Maps Assets
  var routePolyline: GMSPolyline!
  var styles: [GMSStrokeStyle]!
  var routePath: GMSMutablePath!
  var startMarker = GMSMarker()
  var destinationMarker = GMSMarker()
  let marker = GMSMarker()
  var routeSteps: [Steps]!

  
 //LocationManager Assets
  let locationManager = CLLocationManager()
  var originCoordinate: CLLocationCoordinate2D!
  var destinationCoordinate: CLLocationCoordinate2D!
  var locValue:CLLocation!
  var oldLocationCenter:CLLocation!

  var checkingLocation:Bool = false
  var headingAvailable = false
  var currentStepIndex: Int!
  var stepDistance: Double!
  var activeInstruction:String!
  var thresholdDistanceForAudio:Double = 100
  var activerow = 0
  

  override func viewDidLoad() {
    super.viewDidLoad()
    self.uiSetup()
    txtToSpeech = TextToSpeech.sharedInstance
    locValue = CLLocation.init(latitude: 30.705459, longitude: 76.727875)
    marker.tracksViewChanges = true
    marker.icon = UIImage(named:"navigationCC")
    marker.map = gMap
    self.setCurrentLocationOnMap()
    self.intializePolyLinesMarkerProperties()


    let del = Delivery.init(deliveryLocation: CLLocationCoordinate2D.init(latitude: 27.1767, longitude: 78.0081),
                            identifier: "Taj Mahal Navigation",
                            origin: CLLocationCoordinate2D.init(latitude: 30.705459, longitude: 76.727875),
                            recieverName: "John Deo",
                            recieverNumber: "+919888633866",
                            pickupMainInstruction: "Congrats! You have reached Mathura",
                            pickupSubInstruction: "The City of Gods",
                            deliveryMainInstruction: "Welcome to Agra",
                            deliverySubInstruction: "The Taj Mahal State")
    let wayPoint0 = Waypoints.init(waypointLocation: CLLocationCoordinate2D.init(latitude: 30.705707154487524, longitude: 76.72612845897675),
                                   identifier: "PickUp",
                                   pointRecieverName: "Micky",
                                   pointReceiverPhone: "+919888457834",
                                   waypointMainInstruction: "Pick Good No.234 from Micky",
                                   waypointSubInstruction: "Move Ahead to Next Location",
                                   delivery: del)
    let wayPoint1 = Waypoints.init(waypointLocation: CLLocationCoordinate2D.init(latitude: 28.7041, longitude: 77.1025),
                                   identifier: "PickUp",
                                   pointRecieverName: "Micky",
                                   pointReceiverPhone: "+919888457834",
                                   waypointMainInstruction: "Pick Good No.234 from Micky",
                                   waypointSubInstruction: "Move Ahead to Next Location",
                                   delivery: del)
  
    let wayPoint2 = Waypoints.init(waypointLocation: CLLocationCoordinate2D.init(latitude: 27.4924, longitude: 77.6737),
                                   identifier: "Drop Off",
                                   pointRecieverName: "Doe",
                                   pointReceiverPhone: "+91987399323",
                                   waypointMainInstruction: "Drop Good No.234 to Doe",
                                   waypointSubInstruction: "Move Ahead to Destination",
                                   delivery: del)
    self.myWayPoints = [wayPoint0,wayPoint1,wayPoint2]
  }
  
  
  func uiSetup() {
    vcHelper = VCHelper()
    vcHelper.createRoundButtonWithBoder(btn: self.mActionBtn, boderWidth: 2, boderColor: UIColor.white.cgColor, cornerRadius: 22
    )
    vcHelper.createRoundButtonWithView(btn: self.mSearchView, boderWidth: 2, boderColor: UIColor.white.cgColor, cornerRadius: 22)
    font1 = UIFont.systemFont(ofSize: 15)
    font2 = UIFont.systemFont(ofSize: 25)
  }
  
  
  func setCurrentLocationOnMap() {
    let camera = GMSCameraPosition.camera(withLatitude: self.locValue.coordinate.latitude, longitude: self.locValue.coordinate.longitude, zoom: 20.0)
    gMap.camera = camera
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: self.locValue.coordinate.latitude, longitude: self.locValue.coordinate.longitude)
    marker.title = "Mohali"
    marker.snippet = "Current Location"
    marker.map = gMap
    do {
      // Set the map style by passing the URL of the local file.
      if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
        gMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        NSLog("Unable to find style.json")
      }
      
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
  }
  
  
  func intializePolyLinesMarkerProperties()  {
    routePolyline = GMSPolyline()
    startMarker = GMSMarker()
    destinationMarker = GMSMarker()
    self.routePolyline.map = self.gMap
    self.routePolyline.strokeColor = UIColor(red:0.91, green:0.00, blue:0.53, alpha:1.0)
    self.routePolyline.strokeWidth = 8.0
    routePath = GMSMutablePath()
  }
  
  
  func navigateToDestiny()  {
    let destinationVC = self.storyboard?.instantiateViewController(withIdentifier:"DestinyVCID") as! DestinyVC
    self.present(destinationVC, animated: true, completion: nil)
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func mActionBtn(_ sender: UIButton) {
    if sender.title(for: .normal) == "Start Route"{
      locationManager.requestAlwaysAuthorization()
      if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        //  locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
      }
      sender.setTitle("Viewing Route", for: .normal)
    }
    
  }
  
  
  //MARK: Text to speech for upcoming instruction
  func checkAndPlayRouteAudio(activeStep:Steps,instruction:String?)  {
    let endLocation = CLLocation.init(latitude: (activeStep.end_location?.lat)!, longitude: (activeStep.end_location?.lng)!)
    let EndPointdistance = endLocation.distance(from: self.locValue)
    if let direction = instruction{
    
      if EndPointdistance < thresholdDistanceForAudio && direction != self.activeInstruction{
        self.activeInstruction = direction
        txtToSpeech.triggerAudioWithText(speechText: self.activeInstruction)
      }
    }

  }

  
}


//MARK: TableViewDataSource & TableViewDelegates for Instruction Set Display
extension ViewController:UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.routeSteps != nil{
      return self.routeSteps.count
    }
     return 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsViewCellID", for: indexPath) as! InstructionsViewCell
    let currentStep = self.routeSteps[indexPath.row]
    cell.mInstructImgView.image = #imageLiteral(resourceName: "up")
    if let directionSymbol = currentStep.maneuver{
      if let directionSign = UIImage(named:directionSymbol){
        cell.mInstructImgView.image = directionSign
      }

    }
    cell.mInstructLbl.font = font1
    if indexPath.row == 0{
       cell.mInstructLbl.font = font2
    }
    switch indexPath.row {
    case 0:
      cell.mInstructImgView.image = #imageLiteral(resourceName: "selectionDot")
      break
    default:
      print("abc")
      break
    }
    cell.mInstructLbl.text = currentStep.html_instructions!.html2String
    cell.mDistanceLbl.text = (currentStep.distance?.text)! 
    return cell
  }
  
}

extension ViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

//MARK: Route Creation from Waypoint Model
extension ViewController {
  func calculateAndPresentNavigation(waypointList:[Waypoints],present:Bool)  {
    print(waypointList)
    self.drawRouteforPickup(map: gMap, waypointList: self.myWayPoints)
  }
  
  
  func drawRouteforPickup(map:GMSMapView,waypointList:[Waypoints]) {
    let activeDelivery = waypointList[0].delivery!
    let originCordinates =  "\(String(activeDelivery.origin.latitude)),\(String(activeDelivery.origin.longitude))"
    let originInfo = ["header":"Origin","subheader":"Starting Location"]
    let destinationCordinates =  "\(String(activeDelivery.deliveryLocation.latitude)),\(String(activeDelivery.deliveryLocation.longitude))"
    let destinationInfo = ["header":"Destination","subheader":activeDelivery.deliveryAddress!]
    
    
    self.getDirections(mapView: map, originCordinates: originCordinates, originInfo: originInfo, destinationCordinates: destinationCordinates, destinationInfo: destinationInfo, waypoints:waypointList, travelMode: "driving"){ (data, error) -> Void in
      
    }
    
  }
  
  
  
  
  func getDirections(mapView:GMSMapView,
                     originCordinates: String?,
                     originInfo:[String:String],
                     destinationCordinates: String?,
                     destinationInfo: [String:String]!,
                     waypoints:[Waypoints],
                     travelMode: String,
                     callback:@escaping (_ isSuccess: Bool, _ error: String? ) -> Void)  {
  
    let midWayCordinates = self.getCordinatesForWayPoints(waypoints: waypoints)
    let apiKey = Constants.googleMaps.Key
    
    let urlString:String = "https://maps.googleapis.com/maps/api/directions/json?&mode=\(travelMode)&origin=\(originCordinates!)&destination=\(destinationCordinates!)&waypoints=via:\(midWayCordinates)&key=\(apiKey)"
    print(urlString)
    let directionsURL = NSURL(string:urlString )
    DispatchQueue.main.async( execute: { () -> Void in
      if let directionsData = NSData(contentsOf: directionsURL! as URL){
        do{
          let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
          let routeResponse = DirectionResponse.init(dictionary: dictionary as NSDictionary)
          
          let status = routeResponse?.status
          
          if status == "OK" {
            let selectedRoute = (routeResponse?.routes)![0]
            
            
            let legs = selectedRoute.legs
            
            let startLocationDictionary = (legs?[0])?.start_location
            let originCoordinate = CLLocationCoordinate2DMake((startLocationDictionary?.lat)!, (startLocationDictionary?.lng)!)
            
            let endLocationDictionary = legs?[(legs?.count)! - 1].end_location
            let destinationCoordinate = CLLocationCoordinate2DMake((endLocationDictionary?.lat!)!, (endLocationDictionary?.lng!)!)
            
//            Address From Route can also be utilised
//            let originAddress = legs![0].start_address
//            let destinationAddress = legs![legs!.count - 1].end_address!
            
            
            self.startMarker.position = originCoordinate
            self.startMarker.map = mapView
            self.startMarker.icon = GMSMarker.markerImage(with: UIColor.red)
            self.startMarker.title = originInfo["header"]
            self.startMarker.snippet = originInfo["subheader"]
            
            
            self.destinationMarker.position = destinationCoordinate
            self.destinationMarker.map = mapView
            self.destinationMarker.icon = GMSMarker.markerImage(with: UIColor.green)
            
            self.destinationMarker.title = destinationInfo["header"]
            self.destinationMarker.snippet = destinationInfo["subheader"]
            let wayPoint:[Via_waypoint] = legs![0].via_waypoint!
            
            if wayPoint.count > 0 {
              for (index,wayPin) in wayPoint.enumerated() {
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake((wayPin.location?.lat)!, (wayPin.location?.lng)!))
                marker.map = mapView
                marker.icon = GMSMarker.markerImage(with: UIColor.blue)
                let activeWaypoint = waypoints[index]
                marker.title = activeWaypoint.waypointAddress
                marker.snippet = activeWaypoint.waypointMainInstruction
                activeWaypoint.step_index = wayPin.step_index
                
                self.myWayPoints.remove(at: index)
                self.myWayPoints.insert(activeWaypoint, at: index)
                
              }
            }
            
            
            
            var cordinateArray = [CLLocationCoordinate2D]()
            let steps  = (legs![0]).steps!
            self.routeSteps = steps
            for item in steps{
              let polyPoint = item.polyline!.points!
              let path1: GMSPath = GMSPath(fromEncodedPath: polyPoint)!
              for i in 0 ..< path1.count() {
                cordinateArray.append(path1.coordinate(at: i))
              }
              
            }
            
            
            self.routePath = GMSMutablePath()
            for item in cordinateArray{
              self.routePath.add(item)
            }
            
            
            self.routePolyline.path = self.routePath
            self.currentStepIndex = 0
            self.stepDistance = 0
            
            let camPostion = GMSCameraPosition.camera(withLatitude: originCoordinate.latitude, longitude: originCoordinate.longitude, zoom: 18.0)
            let updateCam = GMSCameraUpdate.setCamera(camPostion)
            mapView.animate(with: updateCam)
            
            
            self.mDirectionTableView.reloadData()
            let currentStep = self.routeSteps[self.currentStepIndex]
            callback(true,"")
            if let Strng = currentStep.html_instructions{
            
             let currentStep = Strng.html2String
              self.scrollToSelectedInstruction(instruct: currentStep)

            }
            
            
            
          }
          else {
            print("Unable to draw Route")
            callback(false,"")
            //  self.showAlert(alertTitle: )
            
          }
        }
        catch {
          print("catch")
          //self.showAlert(alertTitle: "Unable to draw Route \(urlString)" as NSString)
          
          callback(false,"")
        }
      }
    })
  }
  
  
  func getCordinatesForWayPoints(waypoints:[Waypoints]) -> String  {
    var cordinateArray = [String]()
    for item in waypoints{
      let cordinates = "\(String(item.waypointLocation!.latitude)),\(String(item.waypointLocation!.longitude))"
      cordinateArray.append(cordinates)
    }
    return cordinateArray.joined(separator: "%7Cvia:")
  }
  
  
}

//MARK: Location Manager delegate to controller Instruction/user location sync over route
extension ViewController:CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    
    if locations.count > 0
    {
      let _  = locations.first
      let location = locations[locations.count-1]
      
      let maxAge:TimeInterval = 60;
      let requiredAccuracy:CLLocationAccuracy = 100;
      print(location.course)
      print(location.horizontalAccuracy)
      NSLog(",,, location : %@",location);
      NSLog("valid locations.....");
      
      locValue = location
      print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
      
      if(checkingLocation == false)
      {
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 20.0)
        oldLocationCenter = location
        marker.position = locValue.coordinate
        self.gMap.animate(to: camera)
        checkingLocation = true
        //     marker.rotation = location.course
        let camPostion = GMSCameraPosition.init(target: CLLocationCoordinate2D(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude), zoom: 18.0, bearing:location.course, viewingAngle: 0)
        let updateCam = GMSCameraUpdate.setCamera(camPostion)
        self.gMap.animate(with: updateCam)
      }
      else
      {
       
//        let speedLimit:CLLocationSpeed  = 1
        
        
        // Heading Movement
        let bbrr = GMSGeometryHeading(oldLocationCenter.coordinate, location.coordinate)
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        marker.position = locValue.coordinate
        if  bbrr > 18{
          
          if headingAvailable == false{
            let camPostion = GMSCameraPosition.init(target: CLLocationCoordinate2D(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude), zoom: 18.0, bearing:bbrr, viewingAngle: 0)
            let updateCam = GMSCameraUpdate.setCamera(camPostion)
            self.gMap.animate(with: updateCam)
            
          }
          
          
        }
        CATransaction.commit()
        oldLocationCenter = location
        self.changeLocationCoordinate(co: location.coordinate.latitude, bo: location.coordinate.longitude)
        //   locationManager.stopUpdatingLocation()
        
      }
      

    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
  {
    headingAvailable = true
    let speedLimit:CLLocationSpeed  = 2
    if  (locValue.speed) > speedLimit && newHeading.trueHeading > 18{
      CATransaction.begin()
      CATransaction.setAnimationDuration(1.0)
      let camPostion = GMSCameraPosition.init(target: CLLocationCoordinate2D(latitude: (locValue.coordinate.latitude), longitude: (locValue.coordinate
        .longitude)), zoom: 18.0, bearing:newHeading.trueHeading, viewingAngle: 0)
      self.gMap.animate(to: camPostion)
      CATransaction.commit()
    }
    
  }
  
  
  
  func changeLocationCoordinate(co: Double, bo: Double){
    
    let Corlocation = CLLocationCoordinate2DMake(co, bo)
    if GMSGeometryIsLocationOnPathTolerance(Corlocation, routePath, false, 30.1) == true{
      
      let currentStepInfo =  self.getCurrentStep(steps: self.routeSteps, cordinates: Corlocation)
      
      if let currentStep = currentStepInfo.0{
        if let Strn = currentStep.html_instructions {
        
         
            let currentStepInst = Strn.html2String
            self.scrollToSelectedInstruction(instruct: currentStepInst)
          
          self.scrollToSelectedInstruction(instruct:currentStepInst)
            if routeSteps[currentStepInfo.2] != nil && currentStepInst != nil{
               self.checkAndPlayRouteAudio(activeStep: routeSteps[currentStepInfo.2], instruction: currentStepInst)
            }
          
        }
      }else{
        print("can't find step")
        
      }
      return
      
    }else{
      self.drawRouteforPickup(map: gMap, waypointList: self.myWayPoints)
      return
    }
    
  }
  
  
  func scrollToSelectedInstruction(instruct:String) {
    let cells = self.mDirectionTableView.visibleCells as! [InstructionsViewCell]
    for item in cells {
      if instruct == item.mInstructLbl.text {
        
        item.mInstructLbl.font = font2
        item.mInstructImgView.image = #imageLiteral(resourceName: "selectionDot")
        if mDirectionTableView.indexPath(for: item) != nil{
          mDirectionTableView.scrollToRow(at: mDirectionTableView.indexPath(for: item)!, at: .top, animated: true)
        }
        
      }
    }
  }
  
  
  
  func getCurrentStep(steps:[Steps],cordinates:CLLocationCoordinate2D) -> (Steps?,Double,Int) {
    
    let currentStep = self.routeSteps[currentStepIndex]
    let point = currentStep.polyline?.points
    let steppath: GMSPath = GMSPath(fromEncodedPath: point!)!
    if GMSGeometryIsLocationOnPathTolerance(cordinates, steppath, false, 10.1) == true{
      
      let loc = CLLocation.init(latitude: (currentStep.start_location?.lat)!, longitude: (currentStep.start_location?.lng)!)
      let stepStart = CLLocation.init(latitude: cordinates.latitude, longitude: cordinates.longitude)
      let distanceInMeters = loc.distance(from: stepStart)
      let coordinateDistance = stepDistance + distanceInMeters
      self.checkingApproachToWaypoint()
      if !(currentStepIndex + 1 < self.routeSteps.count) {

        if currentStepIndex + 1 == self.routeSteps.count{
          self.mActionBtn.setTitle("Reaching", for: .normal)
        }
        return (nil,coordinateDistance,currentStepIndex)
      }
      return (self.routeSteps[currentStepIndex + 1],coordinateDistance,currentStepIndex)
    }else{
      
      let newIndex = currentStepIndex + 1
      var condi = false
      var newStep = Steps(dictionary: NSDictionary())
      if newIndex < self.routeSteps.count {
        newStep = self.routeSteps[newIndex]
        let point = newStep?.polyline?.points
        if point != nil{
          if let steppath: GMSPath = GMSPath(fromEncodedPath: point!){
            condi = GMSGeometryIsLocationOnPathTolerance(cordinates, steppath, false, 10.1)
          }
        }
      }
      if condi == true{
        self.currentStepIndex = newIndex
        self.stepDistance = self.stepDistance + Double((currentStep.distance?.value)!)
        let loc = CLLocation.init(latitude: (newStep?.start_location?.lat)!, longitude: (newStep?.start_location?.lng)!)
        let stepStart = CLLocation.init(latitude: cordinates.latitude, longitude: cordinates.longitude)
        let distanceInMeters = loc.distance(from: stepStart)
        let coordinateDistance = stepDistance + distanceInMeters
        self.activeInstruction = ""
        if !(newIndex + 1 < self.routeSteps.count) {
          let lengths: [NSNumber] = [ NSNumber(value: coordinateDistance + 5), 1000]
          self.routePolyline.spans = GMSStyleSpans(self.routePolyline.path!, styles, lengths, .rhumb)
          self.checkingApproachToWaypoint()
          if currentStepIndex + 1 == self.routeSteps.count{
            self.mActionBtn.setTitle("Reaching", for: .normal)
          }
          
          return (nil,coordinateDistance,currentStepIndex)
        }
        
        return (self.routeSteps[currentStepIndex + 1],coordinateDistance,currentStepIndex)
        
      }else{
        
        var distance :Double = 0
        var currentStep:Steps?
        var Cindex = 0
        var isOnPath = false
        for (index,step) in steps.enumerated() {
          
          
          let currentDistance = Double((step.distance?.value)!)
          let point = step.polyline?.points
          let steppath: GMSPath = GMSPath(fromEncodedPath: point!)!
          if GMSGeometryIsLocationOnPathTolerance(cordinates, steppath, false, 30.1) == true{
            isOnPath = true
            if index != self.currentStepIndex{
              self.currentStepIndex = index
              self.activeInstruction = ""
            }
            
            self.stepDistance = distance
            let lat = step.start_location?.lat
            let lng = step.start_location?.lng
            
            let loc = CLLocation.init(latitude: lat!, longitude: lng!)
            let stepStart = CLLocation.init(latitude: cordinates.latitude, longitude: cordinates.longitude)
            let distanceInMeters = loc.distance(from: stepStart)
            distance = distance + distanceInMeters
            if routeSteps.count > index + 1{
              currentStep = steps[index + 1]
            }
            Cindex = index
          }else{
            if isOnPath == false{
              distance = distance + currentDistance
            }
          }
        }
        return (currentStep,distance,Cindex)
        
        
      }
    }
    
  }
  
  //MARK: Check nearby WayPoint and present Alert
  func checkingApproachToWaypoint() {
    for item in myWayPoints{
      if item.step_index != nil{
        if currentStepIndex == item.step_index!{
          self.showAlert(alertTitle: item.waypointMainInstruction! as NSString)
        }
      }
    }
    
  }
  
  
  func showAlert(alertTitle:NSString){
    let alertController = UIAlertController(title: alertTitle as String, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
      
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }

  
  
}


