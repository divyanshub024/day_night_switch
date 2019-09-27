# DayNightSwitch

A day night switch widget for Flutter.

<img src="https://github.com/divyanshub024/day_night_switch/blob/master/day_night_switch.gif.gif" />

## Installation

Add to pubspec.yaml.

```
dependencies:
  day_night_switch:
```

## Usage

To use plugin, just import package `import 'package:day_night_switch/day_night_switch.dart';`

## Example
```
DayNightSwitch(
  value: val,
  moonImage: AssetImage('assets/moon.png'),
  sunImage: AssetImage('assets/sun.png'),
  sunColor: sunColor,
  moonColor: moonColor,
  dayColor: dayColor,
  nightColor: nightColor,
  onChanged: (value) {
    setState(() {
    val = value;
    });
  },
)
```

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
