# Feedback 

## User flow
To use the compare features seen in User Story 5 and 6, the user gets blocked by the necessity of adding a location to an overview first, then tap on the location, then tap on one of the compare feature buttons and then select a date to finally reach the compare view.

These are way too many steps and seperate views to get to the main feature of our app. While some of the mechanics (like the overview) make sense for usual weather apps we want to focus on the weather compare mode for one location that the user wants to explore. To give a better understanding we created a TabView with the following menu points:

1. Today (representing User Story 2)
2. Forecast (representing User Story 3)
3. History (representing User Story 5 + 6)
4. Search (representing User Story 1)

While the use of color is one of the key elements of our app we have not implemented much of the color features because we dedicated this iteration to getting used to the XCode environment and working with Swift/SwiftUI as well as making API calls to work.

The feedback the MSE team provides us for User Story 4-6 will be incorporated in the assignment 3.

## Removal of Android-style circle buttons
The buttons for the compare functions (seen in User Story 5 + 6) are not in line with the iOS UI Guidelines and their position and styling are more design style that we know from Android apps.

To be more consistent with the iOS UI guidelines we replaced those buttons with a TabView (see User Flow).

## Contrast of Text over Navigation buttons

With the intensive usage of textual data over gradient colors we'll be in danger of some contrast issues that result in text fields that are hard to read. A condition will be implemented that checks for the right background-font color combination.

## Consistency of date picker

In our wireframes we are using two different ways for picking a date (see User Stories 4,5 & 6). This is not a very consistent design, hence can be confusing to the user. In the next iteration we want to use one consistent design for minimizing the user's effort getting used to new elements and for encouraging reusability in the code.

## App Icon
Suggestions were made to give the app icon more indicators that the app has something to do with historic weather data, like a sun combined with a clock. Because we already explored this idea before we got the feedback and it didn't quite work well visually we kept the app icon with the colors that show the main colors that represent the temparature.

However we made the crucial change of removing the rounded corners and leave them as square spaces because iOS will crop the icon accordingly anyway.