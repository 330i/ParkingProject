# Project ParKit

## Inspiration
I once saw a Top Gear challenge. James May's Rolls Royce Corniche Fixed Head with Coachwork by H. J. Mulliner Park Ward against Jeremy Clarkson’s Mercedes 600 Grosser. The two were competing for parking spots in the middle of London. After giving up a parking spot because of the pay-by-phone system, this made me wonder. How are people going to find parking spaces right after the pandemic life?  
Referenced Video: https://www.youtube.com/watch?v=5GFNxvauy28

This prompted me to store the idea for a QR Code based parking app. I was planning to repurpose the scrapped CRHS Parking App project with my friend Prasann but, the idea never branched out. I didn't repurpose the app because the transition to Flutter 2 made it impractical.

## The ParKit App

### Home Screen

https://user-images.githubusercontent.com/55478663/118779012-40dc3580-b850-11eb-85ec-c293912dcd9b.mp4

After signing in with Google, we arrive at the home screen. From here, we have three choices: find nearby spaces, use parking space, and create parking space.

### Create Parking Space

https://user-images.githubusercontent.com/55478663/118779070-52254200-b850-11eb-9dea-c97afe1c3f25.mp4

To create a parking space, we first press the plus icon on the Create Parking Space block. Then, go to the location of the parking space. Then, press the blue button. Then, press the blue button again. After that, set the price. Finally, you will get a QR Code for the parking space. Take a screenshot and print the QR Code. Then, place the QR Code on the parking spot. If you cannot take a screenshot, you can access the QR Code by tapping the parking space on the Create Parking Space block. Although not seen in the video, you can delete your parking space.

### Find Nearby Parking Spaces

https://user-images.githubusercontent.com/55478663/118779110-594c5000-b850-11eb-9ddf-69d54dce1f03.mp4

The Find Nearby Spaces page presents a map. Because I might use Google Cloud credits on a different project, the current version uses OpenStreetMaps. On this page, there are nearby parking spaces. All spaces rendered in the map are nearest based on the first four characters of the Plus Codes.

### Use Parking Space

https://user-images.githubusercontent.com/55478663/118779134-60735e00-b850-11eb-8aa1-cf1332a8f7eb.mp4

The QR Codes of parking spots are scanned using the QR Code reader in the app. ParKit was going to use the Square payment service but, because payment service was the last of my priorities (since this is a demonstration app), I decided to leave it out. To check out of the parking space, press the Checkout Parking Space block.

## Technical Side of Things

### User Interface and Backend

The user interface used in this app is Flutter. Flutter is a framework of Dart. Flutter and Dart are developed by Google. Both run efficiently as they compile to native code. I decided to use Flutter as I am familiar with it.

### Database

The database of the app uses Google's Firebase Firestore. The database is not only efficient but also pairs well with Flutter and Firebase Authentication. The hierarchical structure of the Document-based Database also helps with making development swift.

### Open Location Code

Open Location Codes or Plus Codes are a system of coordinates developed by Google's Zurich office. It uses eight characters plus additional characters, thus its plus name. Each character represents a subdivision of Earth, and more characters mean more accuracy.  
You can learn more here: https://maps.google.com/pluscodes/

## Unresolved Problems
 - As mentioned before, there is no transaction service.
 - The map disappears when zoomed in too far.
