// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ble-hid
import gpio

main:
  mouse := ble-hid.Mouse --name="Toit Mouse"

  boot-button := gpio.Pin 0 --input

  print "Waiting for button press"
  // The 'boot' button is connected to GPIO 0 which is a strap pin,
  // pulled high. When pressed, it goes low.
  boot-button.wait-for 0

  5.repeat:
    mouse.move 15 10
    sleep --ms=10
    mouse.click --left
    sleep --ms=500
