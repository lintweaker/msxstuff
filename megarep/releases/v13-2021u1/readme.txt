#MegaReport v1.3 2021u1 release.

Changes:
- Audio: Detect OPL4 and amount of wavetable RAM
- Audio: Detect MSX-AUDIO MBIOS
- RTC: Detect most common (partial) initialization issues
- CPU: Detect Panasonic Turbo CPU and show mode
- Disk: Basic detection for Nextor diskroms.
- Added basic detection for OCM PLD FPGA implementations
- Fixed current memory display for systems with 4MB of RAM
- Fixed max memory of 65535 Kb display. It was printed in reverse

#How to use
Download to your (real/emulated)MSX2 or higher by putting it on a floppy or supported uSD/SD/CF card.
Boot into basic and execute:
`bload "megarep.bin",r`

