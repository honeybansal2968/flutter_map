# Map Location Search App

A Flutter app that displays a map with the current location and allows users to search for locations and toggle between satellite and normal views. This project integrates Google Maps with the ability to fetch and display the user's current location and allows users to search for specific places via a text field.

## Features
- **Current Location**: Upon startup, the app asks for permission and displays the user's current location on the map.
- **Search Location**: Users can search for any place (city name, address) via the text field, and the map updates to show the searched location.
- **Map Type Toggle**: Users can toggle between normal and satellite map views.

## App Structure

### Screens
This app has a single screen that combines user input for location search and the map display.

- **TextField**: Located at the top of the screen for users to enter and search for locations.
- **Google Map**: Displayed below the `TextField` to show either the user's current location or the location based on the user's search query.
- **Map Layer Toggle**: A button in the `AppBar` allows switching between normal and satellite views.

---

## Data Flow

The app follows a straightforward flow for fetching and displaying the location data, which is outlined below:

1. **Initial Load (Current Location)**:
    - Upon app startup, the `initState()` method in the `LocationSearchMapScreen` widget is triggered.
    - The app checks for location permissions using the `geolocator` package. If permissions are granted, the current location is fetched.
    - The user's current coordinates are retrieved using `Geolocator.getCurrentPosition()` and stored in a `LatLng` object.
    - The map is centered on the user's current location with a marker displayed.

2. **User Location Search**:
    - The user can enter a location (e.g., a city or address) in the `TextField` and tap the search button.
    - The `geocoding` package is used to convert the location string into coordinates.
    - If the location is found, the app updates the map to show the new location, centers the map, and places a marker on the searched location.
    - If the location is not found, an error message is shown to the user.

3. **Map Layer Toggle**:
    - The user can toggle between satellite and normal map views by tapping the layer icon in the `AppBar`.
    - The app's state is updated to switch between `MapType.normal` and `MapType.satellite` for the Google Map.

---

## Code Breakdown

### LocationSearchMapScreen Widget

- **TextField for Location Input**:
  - The user enters a location in the `TextField` at the top of the screen.
  - The input is captured using a `TextEditingController`, and when the search button is pressed, the `_searchLocation` function is called.

- **Google Map**:
  - `GoogleMapController` manages the map and its various attributes like camera position, markers, and map type.
  - Initially, the map shows the user's current location (fetched via `geolocator`). If the user searches for a location, the map is updated to show that new location.
  - A marker is placed at the current or searched location using the `Marker` widget.

- **Map Type Toggle**:
  - A button in the `AppBar` allows users to toggle between normal and satellite map types. This is achieved by switching between `MapType.normal` and `MapType.satellite`.

### Key Functions
- **_fetchCurrentLocation**:
    - Fetches the user's current location and updates the map with the current coordinates. Handles permission and location service errors gracefully.
    
- **_searchLocation**:
    - Converts the user’s text input (address) into geographical coordinates using the `geocoding` package and centers the map on the searched location.
    
- **_toggleMapType**:
    - Switches between satellite and normal views on the map.

---

## How to Run the App

### Prerequisites:
- **Google Maps API Key**: You need to obtain an API key from the Google Cloud Console. Replace `"YOUR_API_KEY"` in the Android `AndroidManifest.xml` and iOS `AppDelegate.swift` with your actual API key.
  
### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/your-repo/map-location-search-app.git
    cd map-location-search-app
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

---

## Project Architecture

The project follows a simple MVC (Model-View-Controller) approach:
- **Model**: The data is primarily the location data fetched using Geolocator and Geocoding packages.
- **View**: The UI is handled by the `LocationSearchMapScreen` widget that combines input and map display.
- **Controller**: Business logic, such as fetching current location, searching for locations, and toggling map types, is placed within the widget's state.

---

## Error Handling

- If location services are disabled or permissions are denied, an error message is displayed to inform the user.
- If the user enters an invalid or non-existent location, an appropriate error message is shown.

---

## Future Enhancements

- **Save Favorite Locations**: Add the ability to save searched locations and revisit them easily.
- **Directions Support**: Provide directions from the current location to a searched location.
- **Nearby Places**: Show nearby places of interest (restaurants, parks, etc.) based on the user's location or search.

---

## Screenshots

### Current Location
![WhatsApp Image 2024-10-05 at 17 42 04_4e212bd8](https://github.com/user-attachments/assets/e6bd4c72-7481-4ea4-9854-bac110db7842)


### Searched Location
![WhatsApp Image 2024-10-05 at 17 42 04_82afce29](https://github.com/user-attachments/assets/0cfc74e8-e6d1-4771-8dd0-1447f88b207a)


### Satellite View
![WhatsApp Image 2024-10-05 at 17 42 05_12a5e076](https://github.com/user-attachments/assets/eb51d579-382c-4360-8fa8-bf38a200f793)


---

## License

This project is licensed under the MIT License.
