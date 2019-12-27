# AoC 2019
This directory contains the solutions to Advent of Code season 2019.

## Breakdowns
I have included an overview of the solution for every day. Certain days also have a detailed breakdown from expression to expression, so if you are not familiar with the q language, you should definitely check these out:

* Day 1: The Tyranny of the Rocket Equation
* Day 3: Crossed Wires
* Day 4: Secure Container
* Day 6: Universal Orbit Map
* Day 8: Space Image Format
* Day 10: Monitoring Station
* Day 16: Flawed Frequency Transmission

Additionally, most of the whiteboxed solutions (see below) also have a breakdown.

## Intcode Debugger
The intcode interpreter used for day 11 and up includes a debugger. It has the following features:
* Disassembly
* Step-by-step or continuous execution
* Breakpoints
* Memory read/write highlighting
* Memory edit and memory labelling
* Trace: run until halt or breakpoint and save a snapshot after each instruction.
* Step between snapshots to effectively run the program backwards.
* Lineage: find where a memory address was written and where the data comes from.
* History: find the value of a memory location for every cycle.
* Output history: find the output instructions and what data they wrote.

To use the debugger, simply navigate to /intcode in the HTTP interface of the q process where you loaded intcode.q into. Note that it will load the HTML framework and replace .z.ph with my custom version.

## Whitebox solutions
Due to the prevalence of the intcode interpreter in this year's puzzles, I decided to reverse engineer every intcode-based puzzle and create a solution that doesn't need an intcode interpreter. These are called dXp1whitebox and dXp2whitebox for every day. An overview of what the intcode program does under the hood is provided, and for most days there is also a breakdown of the whitebox solution.
