# Package

version       = "0.1.0"
author        = "makotia"
description   = "A new awesome twitter client"
license       = "MIT"
srcDir        = "src"
bin           = @["tw"]


# Dependencies

requires "nim >= 1.4.2"
requires "parsetoml"
requires "twitter"
