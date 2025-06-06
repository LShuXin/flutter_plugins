# Diff Match Patch

This is a port of [google-diff-match-patch](https://code.google.com/p/google-diff-match-patch/)
library to Dart. Initially maintained by localvoid, handed off to jheyne for upgrades.

## Algorithms

This library implements Myer's diff algorithm which is generally considered to
be the best general-purpose diff. A layer of pre-diff speedups and post-diff
cleanups surround the diff algorithm, improving both performance and output
quality.

This library also implements a Bitap matching algorithm at the heart of a
flexible matching and patching strategy.

```agsl
apples-Mac-mini-1243:diff_match_patch-0.4.1 apple$ flutter test
00:01 +175: All tests passed! 
```