MU CS424, Fall 2015
-------------------
Assignment 2: Haskell
=====================

The goal of this assignment is to do some financial programming in
Haskell, using Monads in the process.

Consider the following gamble.

You can bet some amount of money ```x```.  A
[dreidel](https://en.wikipedia.org/wiki/Dreidel) is spun, with the
following unusual rules: if the dreidel comes up ג you receive 10x,
otherwise you lose your bet of x.  Since there is a ```1/4``` chance
of a ג, your expected return is ```(1/4) * 10 * x = (5/2) * x```, so
your expected return is to more than double your bet.  This is a
gamble you *have* to take!

You start with an amount of money ```y0```.  There are ten rounds of
play, each play you bet ```p``` times however much money you have,
where ```p``` is some number between 0 and 1.

If you set ```p=1```, you are almost certain to lose all your money,
since the odds of winning all ten bets is 1 in 1,048,576, worse than
one in a million.  (Although if you *do* win all ten bets you'll end
up with an awful lot of money!)

If you set ```p=0```, you won't lose any money, but you also won't win
any money.

Your assignment is to:

* Use the Dist Monad (see Haskell/Dist.hs) to calculate the
  distribution of the amount of money you'll have if you start with a
  pot of y and bet a fraction p of what you have for n rounds.

````Haskell
dreidelDreidelDreidel :: Double -> Double -> Int -> Dist Double
````

* Write a function
    ````Haskell
    mean :: Dist Double -> Double
    ````
	which calculates the mean value of a distribution of doubles.

* Find (by plotting and trial and error to give a rough value, or by
  writing an optimization routine for some extra credit) a value of p
  which maximizes your expected return after ten rounds of play
  starting with a pot of 1000, i.e., find ```p``` which maximizes
  ```mean (dreidelDreidelDreidel 1000 p 10)```.

* Let us define
    ````Haskell
    prHaveMoreThan target y0 p n = mean $ fmap (fromIntegral . fromEnum . (>= target)) $ dreidelDreidelDreidel y0 p n
    ````
	which calculates the probability of ending up with more than ```target```.

	Find (again, by an optimization routine for extra credit) a value
	of ```p``` which maximizes the chance of having over 4000 after
	ten rounds of play starting with a pot of 1000, i.e., find ```p```
	which maximizes ```mean (moreThan 4000 1000 p 10))```.  What is
	this value of ```p```?  What is the probability of ending up
	with over 4000 using that value?  What is the expected (i.e.,
	mean) amount ended up with?

What to turn in
===============

* a *single* file
* without anything unusual (like spaces or unicode) in the filename
* with extension .hs
* that loads and runs in ghci so I can test it
* that includes ```import Dist```
* that answers the above questions requiring answers in comments, with
  commented-out runs showing your work

* **DUE** noon, Thur 17-Dec-2015

Happy Hanukkah!
===============
