# Mobiquity - Mobile iOS Developer Test

This project is the outcome of Mobiquity developer Test. Tasks is to implement single view application to search images from flickr.
<br>
<br>
<p align="center">
<img src = "README Files/cricket.png" height = 300>
<img src = "README Files/football.png" height = 300>
<img src = "README Files/search_history.png" height = 300>
</p>

### Technical Description
Since this app is single view, i have decided to implement using **MVVM**, and **Coordinator** pattern to decouple the navigation from view controller. No third party libraries have been used except **SnapKit** and **SwiftLint**

NSCache is used to cache recipe images locally.

### Testing
Unit Tests are part of this assignment, and implemented using  [**Nimble/Quick**](https://github.com/Quick/Nimble), matcher framework for BDD. Around 50% of the cods have been covered using unit tests.
<br>
<br>
<img src = "README Files/test_coverage.png">

### Instructions
- Clone this develop branch.
- Run **pod install** to install all the dependencies.

###  Improvements
- Implement UITests and Snapshot testing.
- Implement Mock configuration to run app offline.
- Use NSOperation to create more efficient image caching.
- Use babelish and SwiftGen to localize strings.
