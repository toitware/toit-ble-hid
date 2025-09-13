// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

/**
The usage IDs of the keyboard/keypad page.

HID Usage Tables, section 10 (Keyboard/Keypad):
  https://usb.org/sites/default/files/hut1_21.pdf
*/

/**
Error Roll Over.

Not a real key.
*/
ERROR-ROLL-OVER ::= 0x01

/**
POST Fail.

Not a real key.
*/
POST-FAIL ::= 0x02

/**
ErrorUndefined.

Not a real key.
*/
ERROR-UNDEFINED ::= 0x03

/** The 'a'/'A' key on a typical QWERTY keyboard. */
A ::= 0x04
/** The 'b'/'B' key on a typical QWERTY keyboard. */
B ::= 0x05
/** The 'c'/'C' key on a typical QWERTY keyboard. */
C ::= 0x06
/** The 'd'/'D' key on a typical QWERTY keyboard. */
D ::= 0x07
/** The 'e'/'E' key on a typical QWERTY keyboard. */
E ::= 0x08
/** The 'f'/'F' key on a typical QWERTY keyboard. */
F ::= 0x09
/** The 'g'/'G' key on a typical QWERTY keyboard. */
G ::= 0x0A
/** The 'h'/'H' key on a typical QWERTY keyboard. */
H ::= 0x0B
/** The 'i'/'I' key on a typical QWERTY keyboard. */
I ::= 0x0C
/** The 'j'/'J' key on a typical QWERTY keyboard. */
J ::= 0x0D
/** The 'k'/'K' key on a typical QWERTY keyboard. */
K ::= 0x0E
/** The 'l'/'L' key on a typical QWERTY keyboard. */
L ::= 0x0F
/** The 'm'/'M' key on a typical QWERTY keyboard. */
M ::= 0x10
/** The 'n'/'N' key on a typical QWERTY keyboard. */
N ::= 0x11
/** The 'o'/'O' key on a typical QWERTY keyboard. */
O ::= 0x12
/** The 'p'/'P' key on a typical QWERTY keyboard. */
P ::= 0x13
/** The 'q'/'Q' key on a typical QWERTY keyboard. */
Q ::= 0x14
/** The 'r'/'R' key on a typical QWERTY keyboard. */
R ::= 0x15
/** The 's'/'S' key on a typical QWERTY keyboard. */
S ::= 0x16
/** The 't'/'T' key on a typical QWERTY keyboard. */
T ::= 0x17
/** The 'u'/'U' key on a typical QWERTY keyboard. */
U ::= 0x18
/** The 'v'/'V' key on a typical QWERTY keyboard. */
V ::= 0x19
/** The 'w'/'W' key on a typical QWERTY keyboard. */
W ::= 0x1A
/** The 'x'/'X' key on a typical QWERTY keyboard. */
X ::= 0x1B
/** The 'y'/'Y' key on a typical QWERTY keyboard. */
Y ::= 0x1C
/** The 'z'/'Z' key on a typical QWERTY keyboard. */
Z ::= 0x1D

/** The '1'/'!' key on a typical QWERTY keyboard. */
ONE ::= 0x1E
/** The '2'/'@' key on a typical QWERTY keyboard. */
TWO ::= 0x1F
/** The '3'/'#' key on a typical QWERTY keyboard. */
THREE ::= 0x20
/** The '4'/'$' key on a typical QWERTY keyboard. */
FOUR ::= 0x21
/** The '5'/'%' key on a typical QWERTY keyboard. */
FIVE ::= 0x22
/** The '6'/'^' key on a typical QWERTY keyboard. */
SIX ::= 0x23
/** The '7'/'&' key on a typical QWERTY keyboard. */
SEVEN ::= 0x24
/** The '8'/'*' key on a typical QWERTY keyboard. */
EIGHT ::= 0x25
/** The '9'/'(' key on a typical QWERTY keyboard. */
NINE ::= 0x26
/** The '0'/'')' key on a typical QWERTY keyboard. */
ZERO ::= 0x27

/** The 'Enter' key. */
ENTER ::= 0x28
/** The 'Escape' key. */
ESCAPE ::= 0x29
/** The 'Backspace' key. */
BACKSPACE ::= 0x2A
/** The 'Tab' key. */
TAB ::= 0x2B
/** The 'Spacebar' key. */
SPACE ::= 0x2C
/** The '-'/'_' key. */
MINUS ::= 0x2D
/** The '='/'+' key. */
EQUAL ::= 0x2E
/** The '['/'{' key. */
LEFT-BRACKET ::= 0x2F
/** The ']'/'}' key. */
RIGHT-BRACKET ::= 0x30
/** The '\\'/'|' key. */
BACKSLASH ::= 0x31
/** The non-US '#' and '~' key. */
NON-US-POUND ::= 0x32
/** The ';'/':' key. */
SEMICOLON ::= 0x33
/** The '\''/'"' key. */
APOSTROPHE ::= 0x34
/** The '`'/'~' key. */
GRAVE ::= 0x35
/** The ','/'<' key. */
COMMA ::= 0x36
/** The '.'/'>' key. */
PERIOD ::= 0x37
/** The '/'/'?' key. */
SLASH ::= 0x38
/** The 'Caps Lock' key. */
CAPS-LOCK ::= 0x39
/** The 'F1' key. */
F1 ::= 0x3A
/** The 'F2' key. */
F2 ::= 0x3B
/** The 'F3' key. */
F3 ::= 0x3C
/** The 'F4' key. */
F4 ::= 0x3D
/** The 'F5' key. */
F5 ::= 0x3E
/** The 'F6' key. */
F6 ::= 0x3F
/** The 'F7' key. */
F7 ::= 0x40
/** The 'F8' key. */
F8 ::= 0x41
/** The 'F9' key. */
F9 ::= 0x42
/** The 'F10' key. */
F10 ::= 0x43
/** The 'F11' key. */
F11 ::= 0x44
/** The 'F12' key. */
F12 ::= 0x45

/** The 'Print Screen' key. */
PRINT-SCREEN ::= 0x46
/** The 'Scroll Lock' key. */
SCROLL-LOCK ::= 0x47
/** The 'Pause' key. */
PAUSE ::= 0x48
/** The 'Insert' key. */
INSERT ::= 0x49
/** The 'Home' key. */
HOME ::= 0x4A
/** The 'Page Up' key. */
PAGE-UP ::= 0x4B
/** The 'Delete Forward' key. */
DELETE-FORWARD ::= 0x4C
/** The 'End' key. */
END ::= 0x4D
/** The 'Page Down' key. */
PAGE-DOWN ::= 0x4E
/** The 'Right Arrow' key. */
RIGHT-ARROW ::= 0x4F
/** The 'Left Arrow' key. */
LEFT-ARROW ::= 0x50
/** The 'Down Arrow' key. */
DOWN-ARROW ::= 0x51
/** The 'Up Arrow' key. */
UP-ARROW ::= 0x52

/** The 'Num Lock' key. */
NUM-LOCK ::= 0x53
/** The 'Keypad /' key. */
KEYPAD-SLASH ::= 0x54
/** The 'Keypad *' key. */
KEYPAD-ASTERISK ::= 0x55
/** The 'Keypad -' key. */
KEYPAD-MINUS ::= 0x56
/** The 'Keypad +' key. */
KEYPAD-PLUS ::= 0x57
/** The 'Keypad Enter' key. */
KEYPAD-ENTER ::= 0x58
/** The 'Keypad 1' key. */
KEYPAD-ONE ::= 0x59
/** The 'Keypad 2' key. */
KEYPAD-TWO ::= 0x5A
/** The 'Keypad 3' key. */
KEYPAD-THREE ::= 0x5B
/** The 'Keypad 4' key. */
KEYPAD-FOUR ::= 0x5C
/** The 'Keypad 5' key. */
KEYPAD-FIVE ::= 0x5D
/** The 'Keypad 6' key. */
KEYPAD-SIX ::= 0x5E
/** The 'Keypad 7' key. */
KEYPAD-SEVEN ::= 0x5F
/** The 'Keypad 8' key. */
KEYPAD-EIGHT ::= 0x60
/** The 'Keypad 9' key. */
KEYPAD-NINE ::= 0x61
/** The 'Keypad 0' key. */
KEYPAD-ZERO ::= 0x62
/** The 'Keypad .' key. */
KEYPAD-PERIOD ::= 0x63

/** The non-US backslash and '|' key. */
NON-US-BACKSLASH ::= 0x64
/** The 'Application' key. */
APPLICATION ::= 0x65
/** The 'Power' key. */
POWER ::= 0x66
/** The 'Keypad =' key. */
KEYPAD-EQUAL ::= 0x67
/** The 'F13' key. */
F13 ::= 0x68
/** The 'F14' key. */
F14 ::= 0x69
/** The 'F15' key. */
F15 ::= 0x6A
/** The 'F16' key. */
F16 ::= 0x6B
/** The 'F17' key. */
F17 ::= 0x6C
/** The 'F18' key. */
F18 ::= 0x6D
/** The 'F19' key. */
F19 ::= 0x6E
/** The 'F20' key. */
F20 ::= 0x6F
/** The 'F21' key. */
F21 ::= 0x70
/** The 'F22' key. */
F22 ::= 0x71
/** The 'F23' key. */
F23 ::= 0x72
/** The 'F24' key. */
F24 ::= 0x73

/** The 'Execute' key. */
EXECUTE ::= 0x74
/** The 'Help' key. */
HELP ::= 0x75
/** The 'Menu' key. */
MENU ::= 0x76
/** The 'Select' key. */
SELECT ::= 0x77
/** The 'Stop' key. */
STOP ::= 0x78
/** The 'Again' key. */
AGAIN ::= 0x79
/** The 'Undo' key. */
UNDO ::= 0x7A
/** The 'Cut' key. */
CUT ::= 0x7B
/** The 'Copy' key. */
COPY ::= 0x7C
/** The 'Paste' key. */
PASTE ::= 0x7D
/** The 'Find' key. */
FIND ::= 0x7E
/** The 'Mute' key. */
MUTE ::= 0x7F
/** The 'Volume Up' key. */
VOLUME-UP ::= 0x80
/** The 'Volume Down' key. */
VOLUME-DOWN ::= 0x81

/** The 'Locking Caps Lock' key. */
LOCKING-CAPS-LOCK ::= 0x82
/** The 'Locking Num Lock' key. */
LOCKING-NUM-LOCK ::= 0x83
/** The 'Locking Scroll Lock' key. */
LOCKING-SCROLL-LOCK ::= 0x84

/** The 'Keypad Comma' key. */
KEYPAD-COMMA ::= 0x85
/** The 'Keypad Equal Sign' key. */
KEYPAD-EQUAL-SIGN ::= 0x86

/** The 'International 1' key. */
INTERNATIONAL-1 ::= 0x87
/** The 'International 2' key. */
INTERNATIONAL-2 ::= 0x88
/** The 'International 3' key. */
INTERNATIONAL-3 ::= 0x89
/** The 'International 4' key. */
INTERNATIONAL-4 ::= 0x8A
/** The 'International 5' key. */
INTERNATIONAL-5 ::= 0x8B
/** The 'International 6' key. */
INTERNATIONAL-6 ::= 0x8C
/** The 'International 7' key. */
INTERNATIONAL-7 ::= 0x8D
/** The 'International 8' key. */
INTERNATIONAL-8 ::= 0x8E
/** The 'International 9' key. */
INTERNATIONAL-9 ::= 0x8F

/** The 'LANG1' key. */
LANG1 ::= 0x90
/** The 'LANG2' key. */
LANG2 ::= 0x91
/** The 'LANG3' key. */
LANG3 ::= 0x92
/** The 'LANG4' key. */
LANG4 ::= 0x93
/** The 'LANG5' key. */
LANG5 ::= 0x94
/** The 'LANG6' key. */
LANG6 ::= 0x95
/** The 'LANG7' key. */
LANG7 ::= 0x96
/** The 'LANG8' key. */
LANG8 ::= 0x97
/** The 'LANG9' key. */
LANG9 ::= 0x98

/** The 'Alternate Erase' key. */
ALTERNATE-ERASE ::= 0x99
/** The 'SysReq/Attention' key. */
SYSREQ-ATTENTION ::= 0x9A
/** The 'Cancel' key. */
CANCEL ::= 0x9B
/** The 'Clear' key. */
CLEAR ::= 0x9C
/** The 'Prior' key. */
PRIOR ::= 0x9D
/** The 'Return' key. */
RETURN ::= 0x9E
/** The 'Separator' key. */
SEPARATOR ::= 0x9F
/** The 'Out' key. */
OUT ::= 0xA0
/** The 'Oper' key. */
OPER ::= 0xA1
/** The 'Clear/Again' key. */
CLEAR-AGAIN ::= 0xA2
/** The 'CrSel/Props' key. */
CRSEL-PROPS ::= 0xA3
/** The 'ExSel' key. */
EXSEL ::= 0xA4

