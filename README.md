# Live Location Tracker

This is a Flutter project with minimal features for tracking live location on iOS and Android.

- App settings ready for iOS, for now. Will be ready with Android settings in a bit.
- *Screen-1* consists of only two buttons
  - `Share live location` : Tap this button to start sending your device location data to (Firebase) server. The app continues to send data while the app is active. Closing the app or any activity that stops the app from being active, stops the app from sending the data. You would need to tap the button again to restart sending data.
  - `Track live location` : Tap this button to move to *Screen-2* to track live location (as per data obtained from server) on google map. If you have tapped the first button to share your own location and then moved to the location tracking screen, then you will get to see your own location live on map. Or else, you would need a second device actively sharing it's location data at that moment for you track it's live location. Note that, only one device should share it location at a time. If two or more device keeps sharing their location at the same time, the device tracking their location will see their different locations interfering with each others data (intertwined) rendering a disastrous tracking experience! On the other hand, if none is sharing location at a moment, then the last stored location in the server will be shown in the tracker view, which won't update.
- You can zoom and pan the map.
- Again, this is just a minimalist effort to show the scope of development collaboration with the minimum set of features required.

Cheers!
