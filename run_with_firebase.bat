@echo off
echo Running Flutter app with Firebase configuration...

flutter run -d windows ^
  --dart-define=FIREBASE_API_KEY=AIzaSyYourRealApiKey ^
  --dart-define=FIREBASE_APP_ID=1:123456789:web:yourrealappid ^
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=123456789 ^
  --dart-define=FIREBASE_PROJECT_ID=esp32-moha-default-rtdb ^
  --dart-define=FIREBASE_DATABASE_URL=https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app ^
  --dart-define=FIREBASE_STORAGE_BUCKET=esp32-moha-default-rtdb.appspot.com

pause