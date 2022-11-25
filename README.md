# fpga

Repo for the FPGA part of TDAT4295 Computer Design Project @ NTNU,
for group A 2022, Raycraft.
Main FPGA devs are Ole Peder Brandtzæg, Sindre Engøy, and Odd-Erik Frantzen.
Full team is Carl Aarrestad, Ole Peder Brandtzæg, Emma Lu Eikemo, Sindre Engøy, Odd-Erik Frantzen, Børge Lundsaunet, Sivert Olstad, Kasper Midttun Søreide.

To run this on an Arty A7-35T devboard, uncomment the line that defines ISDEV in toplevel.v, and use the run synth_dev.
To run this on our final PCB, featuring an Arty A7-100T ( xc7a100t ftg256 ), keep that line commented out, and use the run synth_pcb.
To run this on some other setup, you need to make your own constraint file to map all these pins.

TODO maybe insert some photos of raycraft here? could be fun to make this repo more useful/fun for others to see
