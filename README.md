# EnvoyMobileAnalysis

This repository contains sample projects for doing performance analysis on the [Envoy Mobile library](https://github.com/lyft/envoy-mobile).

Analysis results are available on Envoy Mobile's documentation [here](https://envoy-mobile.github.io/docs/envoy-mobile/latest/development/performance/performance.html).

## `AnalysisControl`

Simple project which performs a network request every `0.2s` using `URLSession` and no caching.

Utilized to establish a baseline of network requests being made one after another.

To build, simply open the `.xcodeproj` file (it has no external dependencies).

## `AnalysisVariant`

This project utilizes the Envoy Mobile library to make network requests at the same cadence as the control project.

It utilizes CocoaPods to import the library, so building the project requires:

- `pod install` within the project directory
- Build and run the generated `.xcworkspace` file
