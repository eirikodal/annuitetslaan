#!/bin/bash

zig build -Doptimize=ReleaseSmall
cp zig-out/bin/terminbelp_zig ~/.local/bin/terminbelop
chmod +x ~/.local/bin/terminbelop
