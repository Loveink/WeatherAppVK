//
//  LocationConverter.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 23.03.2024.
//

import MapKit

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

  func searchCoordinates(for cityName: String, completion: @escaping ((CLLocationDegrees, CLLocationDegrees)?) -> Void) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = cityName

    let search = MKLocalSearch(request: request)
    search.start { (response, error) in
      let coordinates = response?.mapItems.first?.placemark.coordinate
      let result = coordinates.map { ($0.latitude, $0.longitude) }
      completion(result)
    }
  }

  func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let geocoder = CLGeocoder()

    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
      let city = placemarks?.first?.locality
      completion(city)
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
