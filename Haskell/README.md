## Creating Documentation

In this directory run:

```sh
haddock -o doc --html Die.hs Dist.hs Mebe.hs Monads.hs
```

and open `Haskell/doc/index.html` in a browser. Shortcut, Mac users can use
`open doc/index.html` and Linux users can use `xdg-open doc/index.html`.

If you don't have Haddock installed, simply run `cabal install haddock`
