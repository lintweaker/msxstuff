# sneakyboot
MSX boot sector code used to sneakily boot to (Disk)Basic and start basic code while keeping the screen black.
It uses the MSX clock chip to temporarily set the default colors to black. After MSX Disk BASIC is initialized, the original colors are restored. If you press reset at the wrong time...

This code was used for the MSX Club Gouda Quasar disk magazines and some FCS software releases.
Assembly coding was done in 'WBASS2'.


