# filo

A description of this package.

### Installation

This tool uses the  the libexif dev library.
To install it on Ubuntu ru:n
```
apt install -y libiptc-data libexif-dev libiptcdata0-dev
```
To install it on Mac using brew run:
```
 brew install libexif libiptcdata
```
Export the environment variable for the headers:

```
export CPATH=$(brew --prefix libexif)/include
export C_INCLUDE_PATH=$(brew --prefix libexif)/include
```
To build from Sources, run:
```
 swift build
```
