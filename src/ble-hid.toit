// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import ble show *
import gpio  // TODO(florian): remove this import.


/**
BLE HID (Human Interface Device) device support.
*/

class HidDevice:
  static DEVICE-INFORMATION-SERVICE-UUID_ ::= BleUuid "180A"

  /** The HID service UUID. */
  static HID-SERVICE-UUID_ ::= BleUuid "1812"
  static HID-REPORT-CHARACTERISTIC-UUID_ ::= BleUuid "2A4D"
  static HID-REPORT-MAP-CHARACTERISTIC-UUID_ ::= BleUuid "2A4B"
  static HID-INFORMATION-CHARACTERISTIC-UUID_ ::= BleUuid "2A4A"
  static HID-CONTROL-POINT-CHARACTERISTIC-UUID_ ::= BleUuid "2A4C"

  /** The Battery service UUID. */
  static BATTERY-SERVICE-UUID_ ::= BleUuid "180F"
  /** Battery level characteristic UUID. */
  static BATTERY-LEVEL-CHARACTERISTIC-UUID_ ::= BleUuid "2A19"

  static HID-REPORT-MAP-CONSUMER_ ::= #[
    0x05, 0x0C,        // Usage Page (Consumer).
    0x09, 0x01,        // Usage (Consumer Control).
    0xA1, 0x01,        // Collection (Application).

    0x85, 0x02,        // Report ID (1).

    0x19, 0x00,        // Usage Minimum (0).
    0x2A, 0x3C, 0x02,  // Usage Maximum (572).
    0x15, 0x00,        // Logical Minimum (0).
    0x26, 0x3C, 0x02,  // Logical Maximum (572).
    0x95, 0x01,        // Report Count (1).
    0x75, 0x10,        // Report Size (16).
    0x81, 0x00,        // Input (Data, Array, Abs).
    0xC0               // End Collection.
  ]

  static HID-REPORT-MAP-MOUSE_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop).
    0x09, 0x02,        // Usage (Mouse).
    0xA1, 0x01,        // Collection (Application).

    0x85, 0x02,        //   Report ID (2).

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

    // X and Y (signed 8-bit).
    0x05, 0x01,        //     Usage Page (Generic Desktop).
    0x09, 0x30,        //     Usage (X).
    0x09, 0x31,        //     Usage (Y).
    0x15, 0x81,        //     Logical Minimum (-127).
    0x25, 0x7F,        //     Logical Maximum (127).
    0x75, 0x08,        //     Report Size (8).
    0x95, 0x02,        //     Report Count (2).
    0x81, 0x06,        //     Input (Data, Var, Rel).

    0xC0,              //   End Collection.
    0xC0               // End Collection.
  ]

  static HID-REPORT-MAP-ABSOLUTE-POINTER_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop)
    0x09, 0x02,        // Usage (Mouse)
    0xA1, 0x01,        // Collection (Application)

    0x85, 0x03,        //   Report ID (3)

    0x09, 0x01,        //   Usage (Pointer)
    0xA1, 0x00,        //   Collection (Physical)

    // X and Y absolute 16-bit
    0x05, 0x01,        //     Usage Page (Generic Desktop)
    0x09, 0x30,        //     Usage (X)
    0x09, 0x31,        //     Usage (Y)
    0x16, 0x00, 0x00,  //     Logical Minimum (0)
    0x26, 0xFF, 0x7F,  //     Logical Maximum (32767)
    0x75, 0x10,        //     Report Size (16)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs)

    0xC0,              //   End Collection
    0xC0               // End Collection
  ]

  /** HID v1.11, no country code, flags=RemoteWake+NormallyConnectable. */
  static HID-INFORMATION_ ::= #[0x11, 0x01, 0x00, 0x03]

  name/string
  peripheral_/Peripheral? := ?
  adapter_/Adapter? := ?

  // A HID device must have the HID, Battery and Device Information services.
  hid-service_/LocalService? := ?
  report-characteristic_/LocalCharacteristic? := ?

  battery-service_/LocalService? := ?
  battery-level-characteristic_/LocalCharacteristic? := ?

  keyboard_/Keyboard? := null

  constructor --.name --battery-level/int?=null:
    adapter_ = Adapter
    peripheral_ = adapter_.peripheral --bonding

    hid-service_ = peripheral_.add-service HID-SERVICE-UUID_
    hid-service_.add-read-only-characteristic
        HID-REPORT-MAP-CHARACTERISTIC-UUID_
        --value=Keyboard.HID-REPORT-MAP_
    hid-service_.add-read-only-characteristic
        HID-INFORMATION-CHARACTERISTIC-UUID_
        --value=HID-INFORMATION_
    // Control point. Linux requires boot protocol support.
    hid-service_.add-write-only-characteristic
        HID-CONTROL-POINT-CHARACTERISTIC-UUID_
        --no-requires-response
    hid-service_.add-characteristic
        BleUuid "2A4E"
        --permissions=CHARACTERISTIC-PERMISSION-READ | CHARACTERISTIC-PERMISSION_WRITE
        --properties=CHARACTERISTIC-PROPERTY_WRITE_WITHOUT_RESPONSE | CHARACTERISTIC-PROPERTY_READ
        --value=#[0x01]

    // hid-service_.add-read-only-characteristic
    //     BleUuid "2A01"
    //     --value=#[0xC1, 0x03]  // HID Device Subclass=1 (Boot Interface), Protocol=3 (Keyboard).
    report-characteristic_ = hid-service_.add-notification-characteristic
        HID-REPORT-CHARACTERISTIC-UUID_
    report-characteristic_.add-descriptor
        BleUuid "2908"    // Report-reference.
        --value=#[0x01, 0x01]
        --permissions=CHARACTERISTIC-PERMISSION-READ
        --properties=CHARACTERISTIC-PROPERTY_READ

    battery-service_ = peripheral_.add-service BATTERY-SERVICE-UUID_
    battery-level-characteristic_ = battery-service_.add-read-only-characteristic
        BATTERY-LEVEL-CHARACTERISTIC-UUID_
        --value=(battery-level ? #[battery-level] : #[])


    print Keyboard.HID-REPORT-MAP_.size
    peripheral_.deploy

  close:
    critical-do:
      if peripheral_:
        peripheral_.close
        peripheral_ = null
      if adapter_:
        adapter_.close
        adapter_ = null

  start -> none:
    advertisement := Advertisement
        --services=[
          HID-SERVICE-UUID_,
          BATTERY-SERVICE-UUID_,
          DEVICE-INFORMATION-SERVICE-UUID_
        ]
        --flags=(BLE-CONNECT-MODE-DIRECTIONAL | BLE-ADVERTISE-FLAGS-BREDR-UNSUPPORTED)

    data-blocks := [
      DataBlock.name name,
      DataBlock 0x19 #[0xC1, 0x03],  // Appearance: HID Keyboard.
    ]
    scan-response := Advertisement data-blocks

    peripheral_.start-advertise
        advertisement
        --scan-response=scan-response
        --interval=(Duration --ms=160)
        --allow-connections

  set-battery-level level/int?:
    battery-level-characteristic_.set-value (level ? #[level] : #[])

  report_ report/ByteArray:
    report-characteristic_.write report

  keyboard -> Keyboard:
    if not keyboard_:
      keyboard_ = Keyboard.private_ this
    return keyboard_

/**
A consumer control device.

These remotes come with media keys, volume keys, etc.
They can also be useful to control desktops or phones. For example, the volume-up
  button can be used to trigger a photo capture when the phone camera app is open.

Similarly, a screenshot can be triggered by sending the volume up + volume-down keys
  simultaneously.
*/
class ConsumerControl:
  hid_/HidDevice
  report-id_/int

  constructor.private_ .hid_ .report-id_:

  /**
  Sends the given consumer control usage $code.
  See HID Usage Tables, section 15 (Consumer Page) for usage codes:
    https://usb.org/sites/default/files/hut1_21.pdf

  If $release is true, a key release event is sent after $release-delay
      (default 10ms).
  */
  send code/int --release/bool=false --release-delay/Duration?=null:
    hid_.report_ #[report-id_, code & 0xFF, (code >> 8) & 0xFF]
    if release:
      if not release-delay:
        sleep --ms=10
      else:
        sleep release-delay
      release

  release -> none:
    hid_.report_ #[report-id_, 0x00, 0x00]

  play -> none: send 0xB0 --release
  pause -> none: send 0xB1 --release
  play-pause -> none: send 0xCD --release
  next-track -> none: send 0xB5 --release
  previous-track -> none: send 0xB6 --release
  volume-up -> none: send 0xE9 --release
  volume-down -> none: send 0xEA --release
  mute -> none: send 0xE2 --release

/** A mouse device. */
class Mouse:
  hid_/HidDevice
  report-id_/int

  constructor.private_ .hid_ .report-id_:

/** A keyboard device. */
class Keyboard:
  static REPORT-ID_ ::= 1

  static HID-REPORT-MAP_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop).
    0x09, 0x06,        // Usage (Keyboard).
    0xA1, 0x01,        // Collection (Application).

    // 0x85, 0x01,        //   Report ID (1).

    // Modifier byte.
    0x05, 0x07,        //   Usage Page (Key Codes).
    0x19, 0xE0,        //   Usage Minimum (Keyboard Left Control).
    0x29, 0xE7,        //   Usage Maximum (Keyboard Right GUI).
    0x15, 0x00,        //   Logical Minimum (0).
    0x25, 0x01,        //   Logical Maximum (1).
    0x75, 0x01,        //   Report Size (1).
    0x95, 0x08,        //   Report Count (8).
    0x81, 0x02,        //   Input (Data, Var, Abs).

    // Reserved byte.
    0x75, 0x08,        //   Report Size (8)
    0x95, 0x01,        //   Report Count (1)
    0x81, 0x01,        //   Input (Cnst, Arr, Abs)

    // 6 Keycodes.
    0x05, 0x07,        //   Usage Page (Key Codes).
    0x19, 0x00,        //   Usage Minimum (0).
    0x29, 0x65,        //   Usage Maximum (101).
    0x15, 0x00,        //   Logical Minimum (0).
    0x25, 0x65,        //   Logical Maximum (101).
    0x75, 0x08,        //   Report Size (8).
    0x95, 0x06,        //   Report Count (6).
    0x81, 0x00,        //   Input (Data, Arr, Abs).

    0xC0               // End Collection.
  ]

  hid_/HidDevice

  constructor.private_ .hid_:

  /** Types the given $text assuming the device emulates a QWERTY layout. */
  type-qwerty text/string --delay/Duration=(Duration --ms=5):
    old-key := -1
    text.do: | c/int? |
      code := map-ascii-to-qwerty_ c
      needs-shift := (code >> 8) != 0
      key := code & 0xff

      if old-key == key:
        // We need to release the key to be able to press it again.
        release
        sleep delay

      report --left-shift=needs-shift #[key]
      sleep delay
      old-key = key
    release

  /**
  Maps the given ASCII character $c to the corresponding usage ID.
  See HID Usage Tables, section 10 (Keyboard/Keypad) for usage codes:
    https://usb.org/sites/default/files/hut1_21.pdf
  */
  map-ascii-to-qwerty_ c/int -> int:
    orig-c := c
    if 'A' <= c <= 'Z': c = 'a' + (c - 'A')
    else if c == '!': c = '1'
    else if c == '@': c = '2'
    else if c == '#': c = '3'
    else if c == '$': c = '4'
    else if c == '%': c = '5'
    else if c == '^': c = '6'
    else if c == '&': c = '7'
    else if c == '*': c = '8'
    else if c == '(': c = '9'
    else if c == ')': c = '0'
    else if c == '_': c = '-'
    else if c == '+': c = '='
    else if c == '{': c = '['
    else if c == '}': c = ']'
    else if c == '|': c = '\\'
    else if c == ':': c = ';'
    else if c == '"': c = '\''
    else if c == '~': c = '`'
    else if c == '<': c = ','
    else if c == '>': c = '.'
    else if c == '?': c = '/'

    modifier := 0
    if orig-c != c:
      // Shift needed. We use the left shift.
      modifier = 0xe1 << 8

    if 'a' <= c <= 'z': return modifier + (c - 'a' + 0x04)
    else if '1' <= c <= '9': return modifier + (c - '1' + 0x1E)
    else if c == '0': return modifier + 0x27
    else if c == '\n': return modifier + 0x28
    else if c == 27: return modifier + 0x29
    else if c == '\b': return modifier + 0x2A
    else if c == '\t': return modifier + 0x2B
    else if c == ' ': return modifier + 0x2C
    else if c == '-': return modifier + 0x2D
    else if c == '=': return modifier + 0x2E
    else if c == '[': return modifier + 0x2F
    else if c == ']': return modifier + 0x30
    else if c == '\\': return modifier + 0x31
    else if c == ';': return modifier + 0x33
    else if c == '\'': return modifier + 0x34
    else if c == '`': return modifier + 0x35
    else if c == ',': return modifier + 0x36
    else if c == '.': return modifier + 0x37
    else if c == '/': return modifier + 0x38
    throw "NOT_ASCII"

  /** Release all keys. */
  release -> none:
    hid_.report_ #[
      // REPORT-ID_,
      0x00,  // Modifiers.
      0x00,  // Reserved.
      // 6 key codes.
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]

  report
      --left-control/bool=false
      --left-shift/bool=false
      --left-alt/bool=false
      --left-gui/bool=false
      --right-control/bool=false
      --right-shift/bool=false
      --right-alt/bool=false
      --right-gui/bool=false
      codes/ByteArray:
    if codes.size > 6:
      // Too many keys pressed simultaneously.
      throw "INVALID_ARGUMENT"
    // The modifiers are encoded as a bit-field, from E0 (left-control), to
    // E7 (right gui).
    modifiers := 0
    if left-control: modifiers |= 0b0000_0001
    if left-shift: modifiers |= 0b0000_0010
    if left-alt: modifiers |= 0b0000_0100
    if left-gui: modifiers |= 0b0000_1000
    if right-control: modifiers |= 0b0001_0000
    if right-shift: modifiers |= 0b0010_0000
    if right-alt: modifiers |= 0b0100_0000
    if right-gui: modifiers |= 0b1000_0000
    // Pad the codes with zeros to always send 6 codes.
    padded-codes := codes + (ByteArray (6 - codes.size))
    hid_.report_ #[
      // REPORT-ID_,
      modifiers,  // Modifier.
      0x00,      // Reserved.
      // 6 key codes.
    ] + padded-codes


main:
  hid := HidDevice --name="Toit BLE HID Example"
  print "Advertising as '$hid.name'"
  hid.start

  boot-button := gpio.Pin 0 --input
  while true:
    print "Waiting for button press"
    boot-button.wait-for 0
    hid.keyboard.type-qwerty "Hello world!"
    hid.set-battery-level 75
    boot-button.wait-for 1
