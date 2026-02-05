# DayNightSwitch

A beautiful and highly customizable day/night animated switch widget for Flutter. Perfect for implementing theme toggles, dark mode switches, or any on/off controls with a visual day/night metaphor.

<p align="center">
  <img src="https://raw.githubusercontent.com/divyanshub024/day_night_switch/master/day_night_switch.gif" alt="Day Night Switch Demo" />
</p>

## Features

- 🌞 Smooth animated transition between day and night states
- 🎨 Fully customizable colors for sun, moon, day sky, and night sky
- 🖼️ Custom image support for sun and moon icons
- 📏 Adjustable size to fit your design needs
- ⚡ Easy to implement with minimal code
- 🎯 Built with Flutter's Material Design principles
- 📱 Works on all platforms (iOS, Android, Web, Desktop)

## Installation

Add `day_night_switch` to your `pubspec.yaml`:

```yaml
dependencies:
  day_night_switch: ^1.0.4
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Implementation

Import the package:

```dart
import 'package:day_night_switch/day_night_switch.dart';
```

Use the widget with minimal configuration:

```dart
bool isDarkMode = false;

DayNightSwitch(
  value: isDarkMode,
  onChanged: (value) {
    setState(() {
      isDarkMode = value;
    });
  },
)
```

### Advanced Customization

Customize colors and images to match your app's theme:

```dart
DayNightSwitch(
  value: isDarkMode,
  moonImage: AssetImage('assets/moon.png'),
  sunImage: AssetImage('assets/sun.png'),
  sunColor: Color(0xFFFDB813),
  moonColor: Color(0xFFf5f3ce),
  dayColor: Color(0xFF87CEEB),
  nightColor: Color(0xFF003366),
  onChanged: (value) {
    setState(() {
      isDarkMode = value;
    });
  },
)
```

### Custom Size

Adjust the switch size to fit your layout:

```dart
DayNightSwitch(
  value: isDarkMode,
  size: Size(180.0, 90.0), // Custom width and height
  onChanged: (value) {
    setState(() {
      isDarkMode = value;
    });
  },
)
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `bool` | required | Current state of the switch (true = night, false = day) |
| `onChanged` | `ValueChanged<bool>?` | required | Callback when the switch state changes |
| `sunImage` | `ImageProvider?` | null | Custom image for the sun icon |
| `moonImage` | `ImageProvider?` | null | Custom image for the moon icon |
| `sunColor` | `Color` | `Color(0xFFFDB813)` | Color of the sun (yellow) |
| `moonColor` | `Color` | `Color(0xFFf5f3ce)` | Color of the moon (cream) |
| `dayColor` | `Color` | `Color(0xFF87CEEB)` | Background color for day mode (sky blue) |
| `nightColor` | `Color` | `Color(0xFF003366)` | Background color for night mode (dark blue) |
| `size` | `Size` | `Size(160.0, 88.0)` | Size of the switch widget |
| `dragStartBehavior` | `DragStartBehavior` | `DragStartBehavior.start` | Determines how drag start behavior is handled |
| `mouseCursor` | `MouseCursor?` | null | Cursor for mouse pointer |

## Complete Example

See the [example](example/) directory for a full working example with animated background transitions.

## Connect
- [Twitter](https://twitter.com/divyanshub024)
- [Medium](https://medium.com/@divyanshub024)
- [LinkedIn](https://www.linkedin.com/in/divyanshub024/)

## LICENCE
```
Copyright 2019 Divyanshu Bhargava

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
