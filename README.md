App to display the data collected from multiple
ESP32 microcontrollers with SGP30 multigas sensor.

Built with Flutter.

Current State (outdated):

![image](https://user-images.githubusercontent.com/51988056/178097361-4e3efe77-8fac-4eea-a662-f2d84a3a79ef.png)

![image](https://user-images.githubusercontent.com/51988056/178097384-9533d565-5ca5-4729-92f0-cf53ae3762ba.png)


Current features:
- Users can create an account
- Users can 'follow'/'subscribe' registered ESP32 microcontrollers to get their collected data displayed
- Users can change graph colors
- Users can configure a new ESP Controller via Bluetooth

Planned features:
- Firebase Push Notifications if threshold of eCO2 or TVOC values is exceeded
- Subscribe to Controllers without ever getting a push notification (just for seeing the values)
- Setting your preferred notification interval (after getting a notification, you won't get another one in your specified time e.g. 30 min)
