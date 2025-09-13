// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ble-hid
import ble-hid.keys
import gpio

main:
  keyboard := ble-hid.Keyboard --name="Toit Keyboard"
  keyboard.set-battery-level 75

  boot-button := gpio.Pin 0 --input

  print "Waiting for button press"
  boot-button.wait-for 0

  // Send key presses, assuming a QWERTY layout.
  keyboard.type-qwerty "Hello big world!"

  // Move to the left, skippnig "world!".
  " world!".size.repeat: keyboard.press keys.LEFT-ARROW

  // Select the " big" text.
  " big".size.repeat:
    keyboard.report --left-shift #[keys.LEFT-ARROW]
    keyboard.report --left-shift #[]

  // Copy it, and paste it twice.
  keyboard.press --left-control keys.C
  keyboard.press --left-control keys.V
  keyboard.press --left-control keys.V

  keyboard.close
