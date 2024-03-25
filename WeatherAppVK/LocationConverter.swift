//
//  LocationConverter.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 23.03.2024.
//

import MapKit

func searchCoordinates(for cityName: String, completion: @escaping ((CLLocationDegrees, CLLocationDegrees)?) -> Void) {
  let request = MKLocalSearch.Request()
  request.naturalLanguageQuery = cityName
  
  let search = MKLocalSearch(request: request)
  search.start { (response, error) in
    guard error == nil else {
      print("Error searching for \(cityName): \(error!.localizedDescription)")
      completion(nil)
      return
    }
    
    guard let mapItem = response?.mapItems.first else {
      print("No results found for \(cityName)")
      completion(nil)
      return
    }
    
    let coordinates = mapItem.placemark.coordinate
    completion((coordinates.latitude, coordinates.longitude))
  }
}

func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
  let location = CLLocation(latitude: latitude, longitude: longitude)
  let geocoder = CLGeocoder()
  
  geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
    guard error == nil else {
      print("Reverse geocoding error: \(error!.localizedDescription)")
      completion(nil)
      return
    }
    
    guard let placemark = placemarks?.first else {
      print("No placemarks found for the given coordinates")
      completion(nil)
      return
    }
    
    if let city = placemark.locality {
      completion(city)
    } else {
      print("No city found for the given coordinates")
      completion(nil)
    }
  }
}

final class CityCompleter: NSObject {
  private let completer = MKLocalSearchCompleter()
  private var searchResults: [MKLocalSearchCompletion] = []
  
  override init() {
    super.init()
    completer.delegate = self
    completer.resultTypes = .address
  }
  
  func query(_ query: String, completion: @escaping ([MKLocalSearchCompletion]) -> Void) {
    completer.queryFragment = query
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      completion(self.searchResults)
    }
  }
}

extension CityCompleter: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchResults = completer.results
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    print("Autocomplete search failed with error: \(error.localizedDescription)")
  }
}
