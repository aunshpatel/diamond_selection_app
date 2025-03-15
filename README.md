# Diamond Selection App
This app is created as an answer to test. I am Aunsh Patel.

## Project Structure
The structure of this project is as below:
diamond_selection_app/
│
├── android/                    # Android-specific configurations
├── ios/                        # iOS-specific configurations
├── lib/
│   ├── blocs/                  # All BLoC-related files (Business Logic Component)
│   │   └──  diamond_bloc.dart   # Diamond BLoC
│   ├── data/                   # Data-related files (e.g., external files, data services)
│   │   └──  data.dart           # Example of data file
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
