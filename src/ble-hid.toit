// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import ble show *

import .consumer-control_
import .keyboard_
import .mouse_
import .tablet_

import .appearances as appearances

export ConsumerControl
export Keyboard
export Mouse
export Tablet

/**
BLE HID (Human Interface Device) device support.

This library allows ESP32s to provide BLE HID functionality, such as
  $Keyboard, $Mouse, a $ConsumerControl, or a $Tablet.

There are two different kind of pointer devices: mice and tablets.
  A mouse sends relative movement data, while a tablet sends absolute
  position data.

# Examples

Emulate a keyboard:
```
import ble-hid

main:
  keyboard := ble-hid.Keyboard
  keyboard.type-qwerty "Hello world!"
  keyboard.close
```

Send a volume-up press, when the boot-button is pressed. This can be
  used to trigger a photo capture on Android devices.

```
import ble-hid
import gpio

main:
  pin := gpio.Pin 0 --input
  control := ble-hid.ConsumerControl
  // The 'boot' button is connected to GPIO 0 which is a strap pin,
  // pulled high. When pressed, it goes low.
  pin.wait-for 0
  control.volume-up
```
*/

/*
The BLE HID is based on the USB HID protocol.
Most documentation is for USB only, whereas documentation for BLE HID
  mostly adds the BLE UUIDs.

Resources:
- HID over GATT: https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-1-0/
- USB HID: https://www.usb.org/hid with links to
  * https://www.usb.org/document-library/device-class-definition-hid-111
  * https://usb.org/document-library/hid-usage-tables-16
- BLE assigned numbers: https://www.bluetooth.com/specifications/assigned-numbers/
- HID Service Specification: https://www.bluetooth.com/specifications/specs/human-interface-device-service-1-0/
*/

/**
An HID device, emulating a keyboard, mouse, and/or consumer control.

Instantiate an HID device by constructing a $ConsumerControl, $Keyboard,
  $Mouse, or $Tablet.
*/
abstract class HidDevice:

  /** The Battery service UUID. */
  static BATTERY-SERVICE-UUID_ ::= BleUuid "180F"
  /** Battery level characteristic UUID. */
  static BATTERY-LEVEL-CHARACTERISTIC-UUID_ ::= BleUuid "2A19"

  /** The HID service UUID. */
  static HID-SERVICE-UUID_ ::= BleUuid "1812"
  static HID-INFORMATION-CHARACTERISTIC-UUID_ ::= BleUuid "2A4A"
  static HID-REPORT-MAP-CHARACTERISTIC-UUID_ ::= BleUuid "2A4B"
  static HID-REPORT-CHARACTERISTIC-UUID_ ::= BleUuid "2A4D"
  static HID-REPORT-REFERENCE-DESCRIPTOR-UUID_ ::= BleUuid "2908"

  /** HID v1.11, no country code, flags=RemoteWake+NormallyConnectable. */
  static HID-INFORMATION_ ::= #[0x11, 0x01, 0x00, 0x03]

  name/string
  peripheral_/Peripheral? := ?
  adapter_/Adapter? := ?

  battery-level-characteristic_/LocalCharacteristic? := ?
  report-characteristic_/LocalCharacteristic? := ?

  constructor.from-sub_
      --.name
      --battery-level/int?=null
      --appearance/ByteArray
      --report-map/ByteArray
      --report-id/int
  :
    adapter_ = Adapter
    peripheral_ = adapter_.peripheral --bonding --name=name

    /*
    HID over GATT profile spec, Section 3.
    A Report Host device requires the following services:
    - Battery Service.
    - HID Service.
    - Device Information Service which is automatically provided by the BLE framework.
    */

    battery-service := peripheral_.add-service BATTERY-SERVICE-UUID_
    battery-level-characteristic_ = battery-service.add-read-only-characteristic
        BATTERY-LEVEL-CHARACTERISTIC-UUID_
        --value=(battery-level ? #[battery-level] : #[])

    /*
    HID service specification, section 2.2.
    Required characteristics:
    - HID Information.
    - Report Map. A description of what the report contains.
    - Report Input. This is the characteristic that reports the input data.
    - HID Control Point.
    */

    hid-service := peripheral_.add-service HID-SERVICE-UUID_

    hid-service.add-read-only-characteristic
        HID-INFORMATION-CHARACTERISTIC-UUID_
        --value=HID-INFORMATION_

    combined-map/ByteArray? := null

    assert: report-map[7] == report-id  // Report ID byte in map must match.
    report-characteristic_ = hid-service.add-notification-characteristic
        HID-REPORT-CHARACTERISTIC-UUID_

    // The report-reference descriptor tells the host which report is being sent.
    // The actual report does *not* contain the report ID. See HOGP section 4.8.1.
    report-characteristic_.add-descriptor
        HID-REPORT-REFERENCE-DESCRIPTOR-UUID_
        --value=#[
          report-id,
          0x01,  // Input. (01 = Input, 02 = Output, 03 = Feature)
        ]

    hid-service.add-read-only-characteristic
        HID-REPORT-MAP-CHARACTERISTIC-UUID_
        --value=report-map

    peripheral_.deploy

    advertisement := Advertisement
        --services=[
          HID-SERVICE-UUID_,
          BATTERY-SERVICE-UUID_,
        ]
        --flags=(BLE-CONNECT-MODE-DIRECTIONAL | BLE-ADVERTISE-FLAGS-BREDR-UNSUPPORTED)

    data-blocks := [
      DataBlock.name name,
      DataBlock 0x19 appearance,
    ]
    scan-response := Advertisement data-blocks

    peripheral_.start-advertise
        advertisement
        --scan-response=scan-response
        --interval=(Duration --ms=160)
        --allow-connections

  /**
  Closes this device.
  */
  close -> none:
    critical-do:
      if peripheral_:
        peripheral_.close
        peripheral_ = null
      if adapter_:
        adapter_.close
        adapter_ = null

  /**
  Sets the battery level to $level.

  The battery level is represented as a percentage (0-100).
  */
  set-battery-level level/int?:
    battery-level-characteristic_.set-value (level ? #[level] : #[])
