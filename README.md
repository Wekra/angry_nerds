# HsKA Field App
**Brought to you by Team "Angry Nerds"**

This repository contains a Flutter App which is developed for the Software Architecture Laboratory at the University of Applied Sciences Karlsruhe during the winter term 2018/2019.

### Build (using  Travis CI)
Master: [![Build Status](https://travis-ci.com/Wekra/angry_nerds.svg?branch=master)](https://travis-ci.com/Wekra/angry_nerds)
<br/>
<br/>
Development: [![Build Status](https://travis-ci.com/Wekra/angry_nerds.svg?branch=development)](https://travis-ci.com/Wekra/angry_nerds)

### Coverage (using Coveralls)
Master [![Coverage Status](https://coveralls.io/repos/github/Wekra/angry_nerds/badge.svg?branch=master)](https://coveralls.io/github/Wekra/angry_nerds?branch=master)
<br/>
<br/>
Development: [![Coverage Status](https://coveralls.io/repos/github/Wekra/angry_nerds/badge.svg?branch=development)](https://coveralls.io/github/Wekra/angry_nerds?branch=development)


## Prerequisites
In order to build this app on your system, you will need to have [Flutter](https://flutter.io/) installed (we recommend at least v1.0).

## Building the application

So far, our code is only focused to be build as Android apk.
In order to do this, do the following:

1. Clone this repository and ```cd``` into it.
2. Run ```flutter packages get``` to download the used libraries.
3. If you want to have a fully functional Google Maps Widget, you will need to create a Google Maps API Key and replace the placeholder in the file ```android/app/src/main/res/values/constants.xml```.
4. To build the apk, run ```flutter build apk```. The final apk can be found in ```build/app/outputs/apk/release/``` and is named ```app-release.apk```.
