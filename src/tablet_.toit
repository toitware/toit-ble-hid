// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import .ble-hid

import .appearances as appearances

/** A tablet device. */
class Tablet extends HidDevice:
  static REPORT-ID_ ::= 0x22

  static HID-REPORT-MAP_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop).
    0x09, 0x02,        // Usage (Mouse).
    0xA1, 0x01,        // Collection (Application).

    // The report ID must be the first byte, as BLE HID automatically prepends
    // the ID. The actual report must not contain it. See HOGP section 4.8.1.
    0x85, 0x22,        //   Report ID.

    0x09, 0x01,        //   Usage (Pointer).
    0xA1, 0x00,        //   Collection (Physical).

    // Buttons (3 bits in one byte).
    0x05, 0x09,        //     Usage Page (Buttons).
    0x19, 0x01,        //     Usage Minimum (Button 1).
    0x29, 0x03,        //     Usage Maximum (Button 3).
    0x15, 0x00,        //     Logical Minimum (0).
    0x25, 0x01,        //     Logical Maximum (1).
    0x95, 0x03,        //     Report Count (3).
    0x75, 0x01,        //     Report Size (1).
    0x81, 0x02,        //     Input (Data, Var, Abs).

    // Padding to make a full byte.
    0x95, 0x01,        //     Report Count (1).
    0x75, 0x05,        //     Report Size (5).
    0x81, 0x01,        //     Input (Const, Arr, Abs).

    // X and Y absolute 16-bit.
    0x05, 0x01,        //     Usage Page (Generic Desktop).
    0x09, 0x30,        //     Usage (X).
    0x09, 0x31,        //     Usage (Y).
    0x16, 0x00, 0x00,  //     Logical Minimum (0).
    0x26, 0xFF, 0x7F,  //     Logical Maximum (32767).
    0x75, 0x10,        //     Report Size (16).
    0x95, 0x02,        //     Report Count (2).
    0x81, 0x02,        //     Input (Data,Var,Abs).

    0xC0,              //   End Collection.
    0xC0               // End Collection.
  ]

  last-x_/int := -1
  last-y_/int := -1
  last-buttons_/int := -1

  /**
  Creates a tablet device.

  The $name is typically shown on the host when listing connected devices and must
    be relatively short (preferably <= 10 characters).

  The $appearance is one of the values in the 'appearances' library. See
    $appearances.TABLET for an example.
  */
  constructor --name/string --appearance/ByteArray=appearances.TABLET:
    super.from-sub_
        --name=name
        --appearance=appearance
        --report-map=HID-REPORT-MAP_
        --report-id=REPORT-ID_

  /**
  Moves the mouse pointer to the given $x and $y location.

  The $x and $y values must be in the range 0 to 32767.
  */
  move-to x/int y/int:
    report --x=x --y=y

  /**
  Clicks the mouse buttons.

  Waits for the given $delay before releasing the buttons.
  */
  click
      --left/bool=false
      --right/bool=false
      --middle/bool=false
      --delay/Duration=(Duration --ms=20):
    if last-x_ == -1 or last-y_ == -1:
      throw "Mouse has not been moved"
    report
        --left-button=left
        --right-button=right
        --middle-button=middle
        --x=last-x_
        --y=last-y_
    sleep delay
    report --x=last-x_ --y=last-y_

  /**
  Sends a report.

  The report includes the current state of the mouse buttons and the mouse position.

  The parameters $x and $y must be in the range 0 to 32767.
  */
  report
      --left-button/bool=false
      --right-button/bool=false
      --middle-button/bool=false
      --x/int
      --y/int
  :
    last-x_ = x
    last-y_ = y
    if not (0 <= x <= 32767) or not (0 <= y <= 32767):
      throw "x and y must be in the range 0 to 32767"
    button-byte := 0
    if left-button: button-byte |= 1
    if right-button: button-byte |= 2
    if middle-button: button-byte |= 4
    report-characteristic_.write #[button-byte, x & 0xFF, x >> 8, y & 0xFF, y >> 8]
