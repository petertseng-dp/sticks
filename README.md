# Sticks

Determine the order in which sticks can be removed.

[![Build Status](https://travis-ci.org/petertseng-dp/sticks.svg?branch=master)](https://travis-ci.org/petertseng-dp/sticks)

# Notes

No surprises in this implementation.
Calculate for each of the O(n^2) pairs whether one stick blocks another.
Use this information to make a topological sort.
Given this information, print out all possibilities.

The implementation was fraught with type errors:
Many times I attempted to use `some_hash.map { |k, v| ... }.to_h`, only to find that the types have become `Hash(K|V, K|V)`:

```crystal
h = {1 => "3"}
h.map { |k, v| [k, v] }.to_h
```

This was actually a bit frustrating.
This is a time when I did not appreciate having types.

Finally @asterite had to step in and tell me to use Tuples.

```crystal
h = {1 => "3"}
h.map { |k, v| {k, v} }.to_h
```

Next was a strange problem where simplying saying `if @slope` still allowed for `@slope` to be `nil` inside.
This seemed to not be in keeping with flow-sensitive typing.
The workaround that I finally discovered is to assign it to a local.
I would discover later that this is as https://crystal-lang.org/docs/syntax_and_semantics/if_var.html recommends.
To quote:

> This is because any method call could potentially affect that instance variable, rendering it `nil`.
> Another reason is that another thread could change that instance variable after checking the condition.

The final interesting thing is that a hash with a default value block doesn't store the default value unless explicitly told to.
However, the default value block turned out to be inappropriate for this problem anyway.

These three things combined made this problem take a lot longer than it otherwise would have.

# Source

https://www.reddit.com/r/dailyprogrammer/comments/2oe0px/

Note: inputs/sample5 (taken from the above page) has intersecting lines so its result should not be trusted.
