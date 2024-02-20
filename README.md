# particles

Bunch of particles following your cursor. Built using Hare and Raylib.

## Dependencies:

- (Raylib)[https://www.raylib.com/], version used: 5.0-1 
- (Hare)[https://harelang.org/], version used: hare dev+c50d9288-arch

## Running:

`% hare build -lraylib -o particles main.ha && ./particles`

## Notes:

I did this mostly to play around with Hare, to see how easy it is to link to C from Hare. My conclusion - it is simple enough, plus it seems that Hare already provides most of the things you would need in day-to-day work out of the box. And when you eventually decide that you want to link some C library, you can make decent wrappers and adapt them to your use cases.

Also, while I mostly enjoy using Hare, I would love to see some more work done on the performance side of things.

## Licence

This code is licensed under the terms of 2-clause BSD licence (see `LICENCE` for details).
