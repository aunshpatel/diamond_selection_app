# Diamond Selection App
This diamond selection app is created by me, Aunsh Patel, as an answer to assessment provided on the following link:
https://docs.google.com/document/d/1nN9jZsj6GaUUr2GEXS2Oao0AT32TpBPeY5L5z3OwSME/edit?tab=t.0

## Project Structure:
The structure of this project is as below. I chose to seperate blocs, data value file, models and the screens(UI) folsers so that it would become easier to seperate the processes that are made in order to display data. This would ease the process of pinpointing places where errors might have occurred.
```
diamond_selection_app/
│
├── android/                    # Android-specific configurations
├── ios/                        # iOS-specific configurations
├── lib/
│   ├── blocs/                  # All BLoC-related files (Business Logic Component)
│   │   └──  diamond_bloc.dart  # Diamond BLoC
│   ├── data/                   # Data-related files (e.g., external files, data services)
│   │   └──  data.dart          # Example of data file
│   ├── models/                 # Models for the app (Diamond Model)
│   │   └── diamond_model.dart  # Diamond model (represents a Diamond)
│   ├── screens/                # UI Screens/Pages
│   │   ├── cart_page.dart      # Cart page to show the diamonds added to cart
│   │   └── result_page.dart    # Result page to show the filtered and sorted diamonds
│   │   └── filter_page.dart    # Filter page with sorting controls
│   └── main.dart               # Entry point of the Flutter app
├── linux/                      # Linux-specific configurations
├── macos/                      # MacOS-specific configurations
├── test/                       # Empty folder
├── web/                        # Web-specific configurations
├── windows/                    # Windows-specific configurations
├── pubspec.yaml                # Flutter package dependencies and assets configuration
└── README.md                   # Project information
```
## State Management Logic:
This app uses BLoC(Business Logic Component) for state management. This pattern allows the creator of a project to separate business logic from UI, which would make it easy to make the codebase easy to test.

## Persistent Storage Usage:
To ensure that the data persists even after app restarts, **SharedPreferences** is used for local storage. This app also uses SharedPreferences for persistent storage, allowing data to persist even after the app is closed. This is essential for scenarios where users may want to save their diamond selections.

#### How persistent storage is used in the app:
- Cart Data Persistence: 
  When diamonds are added to or removed from the cart, the cart data is saved into SharedPreferences. This ensures that even after restarting the app, the selected diamonds will remain in the cart.
