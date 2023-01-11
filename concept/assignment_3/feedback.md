# Feedback 

## GitLab

### Merge Request

We were doing merges locally and indivdually with the `git merge` command.

In this assignment we were making use of multiple feature branches and GitLab's merge request features.

### Use Board for ticket management

To track the development state of the user stories and bugs we are making more use of the GitLab board. While we are using it to track the user stories, we also registered some bugs into the board, so not only us, the developers, are aware of it but also code's spectactors and maybe also future contributors.

We also used an internal Trello board for tracking little bugs and todos. You can find the Trello board here: https://trello.com/invite/b/WEXEyTYn/ATTI8d8c05a351ea5b7dea84bb47923862d1E3AB1469/mse
### Adding issues and screenshots to Readme

The readme.md was missing screenshots of the app and its issues. We included them now.


## Landscape Mode
Landscape was locked in the last assignment. We enabled it again and made all the Views useable for landscape mode.

Some layout bugs in `CurrentView` we could solve by wrapping the view in a ScrollView.

## Usage of enums

We are using enums now when we are working with specific strings or constants like in `NetworkError`, `TemperatureUnit`, `TemperatureColorRange` and `LineGraphParameter`.

`LocationManager`'s `authStatus` could still be replaced by an enum.

## Localize strings

Some strings were still hardcoded in assignment 2.

We now localized every string from the UI in the `Localizable` files

## Reverse Coordinates with Mapkit

We were still rendering only the coordinates as a Navigation Title in the app without showing the name of the location.

This we solved with Swift's in-house `CLGeocoder().reverseGeocodeLocation` method.

## OnAppear always fetches API request

We know that every onAppear still fetches API requests.

But because weather is something that could change every minute, we wanted to keep the API calls in `onAppear` so that the user always sees the current weather state.
## Better folder structure

We were aware that the folder structure was not ideal. We now introduced the following folder structure:

### Utilites

Contains methods and services that don't necessarily are part of our app's main data structure and MMVM architecture.

### Model

Contains all data models, especially for Decoding JSON.

### Views

Contains all Views with their corresponding ViewModel

### Repository

Contains the `DayWeatherRepository` and all future repositories that communicate with the Open Meteo APIs and the `Persistence`.


### Persistence

Contains the `Persistence` and Core Data file.


## Avoid Force Unwrapping

We removed all the force unwrappings that mostly were related to defining `Date` objects and replaced them with defining today's date with `Date()`.

## weatherCodeToIcon function doesn't belong in the Persistence

We moved the `weatherCodeToIcon` function from the `Persistence` into `WeatherFunctions` that can be found in the before mentioned `Utilities` folder.
