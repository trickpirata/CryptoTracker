# CryptoTracker
Coin Gecko API implementation using **SwiftUI**, **Combine** and **REALM**. A practice in implementing combine.

## Architecture
The application is built on MVVM+Coordinator. 

## Project structure
The project is using Xcode workspace.
- CryptoTracker holds the application
- CryptoTrackerStorage contains api functions and persistence service
- CryptoTrackerUI contains shared styling and shared views

# Technologies/Dependencies
* Swift Package Manager - dependency management
* Alamofire - https://github.com/Alamofire/Alamofire
* ActivityIndicatorView - https://github.com/exyte/ActivityIndicatorView
* AlamofireNetworkActivityLogger - https://github.com/konkab/AlamofireNetworkActivityLogger
*  SDWebImage - https://github.com/SDWebImage/SDWebImage
* Stinsen - https://github.com/rundfunk47/stinsen

# How to Run
- Open the CryptoTracker.xcworkspace 

# To Dos
- Unit testing 
- Code Cleanup
