# Build_Bump

This package was created to fulfill my own needs of increasing productivity and reducing in deliverying milestones builds. This can an should be improved to achieve new functionalities and customizable configurations. Feel free to open an issue or directly create a PR.

# example

Run command ```flutter pub run bump_build:build```

## What this package does:

This package is intended to abstract the simplest build tasks which includes:
- bumping the build number each time you run the command;
- git commiting the changes made in pubspec.yaml;
- running flutter pub get to consolidate the new build number in native projects;
- building android apk;
- building iOS.

## What this package does not:

It does not accomplish the following (yet):
- integrate with CI/CD tools;
- provide a way to define custom parameters;
- validate native projects configurations.