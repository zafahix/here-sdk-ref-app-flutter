# HERE SDK Reference Application for Flutter

The reference application for the [HERE SDK for Flutter (_Navigate Edition_)](https://developer.here.com/documentation/flutter-sdk-navigate/) shows how a complex and release-ready project targeting iOS and Android devices may look like. You can use it as a source of inspiration for your own HERE SDK based projects - in parts or as a whole.

## Overview

With this blueprint reference application you can see how UX flows can be built for the HERE SDK - covering the main use cases from searching for POIs, planning and picking a route and finally starting the trip to your destination.

- Learn how the [HERE SDK 4.x](https://developer.here.com/products/here-sdk) can be complemented with rich UI for your own application development.
- Discover how to avoid common pitfalls, master edge cases and benefit from optimized end user flows.
- All code using the HERE SDK is implemented in pure Dart following well-established clean code standards.
- On top, the reference application is enriched with tailored graphical assets - adapted for various screen sizes and ready to be used in your own projects.

If you are looking for smaller bits & pieces or just want to get started with the integration of the HERE SDK into a simpler project, you may want to start looking into our [example apps](https://github.com/heremaps/here-sdk-examples/tree/master/examples/latest/navigate/flutter) selection including a stripped down [hello_map_app](https://github.com/heremaps/here-sdk-examples/tree/master/examples/latest/navigate/flutter/hello_map_app) that accompanies the [Developer's Guide](https://developer.here.com/documentation/flutter-sdk-navigate/) for the HERE SDK.

The reference application hosted in this repo focuses on how specific features can be implemented and used within the context of a full blown Flutter application - not only to show the usage of our APIs and the HERE SDK functionality as clear and understandable as possible, but also to show how complex Flutter projects in general can be organized and developed with production quality.

### Supported features (so far)

The HERE Reference App offers a comprehensive range of features designed to enhance your navigation and mapping applications. Some of the supported features include:

- [Search](https://developer.here.com/documentation/flutter-sdk-navigate/dev_guide/topics/search.html): Including suggestions, text search and search along a route corridor using the [search library](https://developer.here.com/documentation/flutter-sdk-navigate/api_reference/search/search-library.html) of the HERE SDK.
- [Routing](https://developer.here.com/documentation/flutter-sdk-navigate/dev_guide/topics/routing.html): As of now, the reference application supports the following transport modes: car, truck, scooter and pedestrian using the [routing library](https://developer.here.com/documentation/flutter-sdk-navigate/api_reference/routing/routing-library.html) of the HERE SDK.
- [Turn-By-Turn Navigation](https://developer.here.com/documentation/flutter-sdk-navigate/dev_guide/topics/navigation.html): Including maneuver instructions with visual feedback and voice guidance using the [navigation library](https://developer.here.com/documentation/flutter-sdk-navigate/api_reference/navigation/navigation-library.html) of the HERE SDK.
- [Offline Maps](https://developer.here.com/documentation/flutter-sdk-navigate/dev_guide/topics/offline-maps.html): Including UI to download, install and update regions using the [maploader library](https://developer.here.com/documentation/flutter-sdk-navigate/api_reference/maploader/maploader-library.html) of the HERE SDK. The application can be operated offline when the in-app offline switch is activated. To operate fully offline, turn also the device's connectivity off.
- [HERE Icon Library](https://github.com/heremaps/here-icons): The app integrates *HERE Icon Library*, a robust set of customizable map icons and markers. These icons are designed to work seamlessly with HERE Maps, providing a consistent look and feel for map elements such as POIs (Points of Interest), routes, and more.

![screenshots](assets/screenshots.png)


### Dependencies

The following dependency is required for the HERE Reference App:

- **[HERE Icon Library](https://github.com/heremaps/here-icons)**: A library of customizable map icons and markers that enhance the visual presentation of map elements within the application.

## Get Started

The reference application for the HERE SDK for Flutter (_Navigate Edition_) requires the following prerequisites:

-  The [HERE SDK for Flutter (_Navigate Edition_), version 4.22.0.0](https://developer.here.com/documentation/flutter-sdk-navigate/4.22.0.0/dev_guide/index.html) is required and needs to be downloaded from the [HERE platform](https://platform.here.com). For now, the _Navigate Edition_ is only available upon request. Please [contact us](https://developer.here.com/help#how-can-we-help-you) to receive access including a set of evaluation credentials.
- If not already done, install the [Flutter SDK](https://flutter.dev/docs/get-started/install). You need at least [version 3.27.4](https://flutter.dev/docs/development/tools/sdk/releases). Newer versions may also work, but are _not guaranteed_ to work.
- Make sure to specify `JAVA_HOME` in your `env` variables. The minimum supported JDK version is Java 8.

On top you need an IDE of your choice. This could be a text editor or IDEs such as [Visual Studio Code](https://code.visualstudio.com/) with the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) or [Android Studio](https://developer.android.com/studio).

Note: If you want to compile, build & run for iOS devices, you also need to have [Xcode](https://developer.apple.com/xcode/) and [CocoaPods](https://cocoapods.org/) installed. If you only target Android devices, Xcode is _not_ required.

Confirm that you meet the overall [minimum requirements](https://developer.here.com/documentation/flutter-sdk-navigate/dev_guide/topics/about.html#minimum-requirements) as listed in the _Developer's Guide_ for the HERE SDK for Flutter (_Navigate Edition_).

### Add the HERE SDK Plugin

Make sure you have cloned this repository and you have downloaded the HERE SDK for Flutter (_Navigate Edition_), see above.

1. Unzip the downloaded HERE SDK for Flutter _package_. This folder contains various files including various documentation assets.
2. Inside the unzipped package you will find a TAR file that contains the HERE SDK _plugin_.
3. Unzip the TAR file and rename the folder to 'here_sdk'. Move it inside the [plugins](./plugins/) folder.

### HERE Icon Library Integration and Fetching Submodules Before Building

To ensure the necessary icon components are available during the build process, we recommend fetching and updating the "
here-icon" submodule. This guarantees that the submodule is checked out at the correct revision specified in the project
configuration. Missing updates can lead to build failures due to missing files.

### Fetching Methods

**1. Using the Command Line:**

This method provides manual control over the update process. Here's how to fetch and update the submodule:

* **Initialize and Update:** Run the following command to initialize (if not already done), fetch changes from the
  remote repository, and update all submodules recursively:

    ```bash
    git submodule update --init --recursive
    ```

* **Verify Specific Commit (Optional):** If a specific commit ID is crucial for the icon library, you can further ensure
  its correct checkout by running:

    ```bash
    git submodule foreach --recursive git fetch
    git submodule foreach --recursive git checkout <commit_id>
    ```

**2. Using a Script (Recommended):**

For a more convenient approach, consider using the provided scripts to automate the initializing and updating of the submodule to the correct revision as defined by the `HERE_ICON_LIBRARY_COMMIT_ID` variable within the script.
If needed, you can also modify this variable to update the submodule to a different commit.

* **On Mac/Linux:**
  Run the provided `update_submodules.sh` script:
    ```bash
    ./update_submodules.sh
    ```


* **On Windows:**
  Run the provided `update_submodules.bat` script:

    ```cmd
    update_submodules.bat
    ```
This will ensure the submodule is initialized and updated as needed.

### Build the Reference Application

1. Set your HERE SDK credentials:
   The credentials are read from the environment variables which are set using --dart-define.
- If you want to set up environment variables from the CLI, run the command:
  ```bash  
  flutter run --dart-define=HERESDK_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID> --dart-define=HERESDK_ACCESS_KEY_SECRET=<YOUR_ACCESS_KEY_SECRET>
  ```
- If you want to run from any IDE, you can add credentials to the .json file for your environment.
  Create a file .env/dev.json as:
  >
  > ```bash
  >{
  >   "HERESDK_ACCESS_KEY_ID": "<YOUR_ACCESS_KEY_ID>",
  >   "HERESDK_ACCESS_KEY_SECRET": "<YOUR_ACCESS_KEY_SECRET>"
  > }
  >```

  And add additional run args in the IDE: `--dart-define-from-file=.env/dev.json`

2. Go to the repository root folder which contains the `pubspec.yaml` and run the terminal command `flutter pub get` to fetch the required dependencies.

3. Open the project in your IDE of choice and execute the Flutter project for your target platform.

#### How to build Flutter apps for Android and iOS

If you are new to Flutter, here are more detailed steps for you. You may also want to consult the official [Flutter](https://flutter.dev) site in general and the [Flutter SDK](https://flutter.dev/docs/development/tools/sdk/overview) documentation in particular first.

- Build for Android:
  - Build an Android APK by executing `flutter build apk --dart-define-from-file=.env/dev.json` or use the command `flutter run --dart-define-from-file=.env/dev.json` to build and run on an attached device.
- Build for iOS:
  - Run `pod install` in the [ios folder](./ios/).
  - Then go back to the repository root folder and type `flutter build ios --dart-define-from-file=.env/dev.json` to build a Runner.app. Type `flutter run --dart-define-from-file=.env/dev.json` to build and run on an attached device.
  - You can open the `/repository root/ios/Runner.xcworkspace` project in Xcode and execute and debug from there.
  - Note: You need to have valid _development certificates_ available to sign the app for device deployment.

Note: You can alternatively also pass the credentails during build by:

```bash
flutter build apk --dart-define=HERESDK_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID> --dart-define=HERESDK_ACCESS_KEY_SECRET=<YOUR_ACCESS_KEY_SECRET>
```

### Troubleshooting

#### Build Error: "unable to find directory entry in pubspec.yaml"

If you're seeing an error like this when building the app:

```
Error: unable to find directory entry in pubspec.yaml: /Users/your-path/.../assets/here-icons/icons/.../...
```

It's likely because the required asset folders were not downloaded. These assets are part of a Git submodule, and must be initialized before building the app.

This commonly happens if you **skipped running** the `update_submodules` script after cloning or pulling the repository.

**Solution:**  
Make sure to run the correct script for your platform from the root of the project:

- **macOS/Linux:**

  ```bash
  ./update_submodules.sh
  ```

- **Windows:**

  ```cmd
  update_submodules.bat
  ```

This ensures all required submodules (including asset folders) are available for the build process.

## Contributing

You can contribute to this open source project and improve it for others. There are many ways to contribute to this project, whether you want to create an issue, submit bug reports or improve the documentation - we are happy to see your merge requests. Have a look at our [contribution guide](./CONTRIBUTING.md) and [code of conduct](./CODE_OF_CONDUCT.md). Happy coding!

## Questions and Support

We provide the code 'AS IS'. Using the source code does not come with any additional grant of customer support or promise of specific feature development on our part. If you have any questions, please [contact us](https://developer.here.com/help#how-can-we-help-you) or check the tag `here-api` on [stackoverflow.com](https://stackoverflow.com/questions/tagged/here-api).

## License

Copyright (C) 2020-2025 HERE Europe B.V.

See the [LICENSE](./LICENSE) file in the root folder of this project for license details.

For other use cases not listed in the license terms, please [contact us](https://developer.here.com/help).

### Note

This application and the HERE SDK itself include open source components which require explicit attribution. Please remember to add open source notices in your project.
Furthermore, we ask you not to re-sell the icons included in this project.
