// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ble-hid
import gpio

main:
  tablet := ble-hid.Tablet --name="Toit Tablet"

  boot-button := gpio.Pin 0 --input

  print "Waiting for button press"
  // The 'boot' button is connected to GPIO 0 which is a strap pin,
  // pulled high. When pressed, it goes low.
  boot-button.wait-for 0

  // Given the resolution of 32767x32767 the coordinates 3000, 3000 are relatively
  // high up on the left.

  tablet.move-to 3000 3000
  sleep --ms=10
  tablet.click --left
  sleep --ms=500

  tablet.move-to 6000 3000
  sleep --ms=10
  tablet.click --left
  sleep --ms=500

  tablet.move-to 3000 6000
  sleep --ms=10
  tablet.click --left
  sleep --ms=500

  tablet.move-to 6000 6000
  sleep --ms=10
  tablet.click --left
