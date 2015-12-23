MU CS424, Fall 2015
-------------------
Assignment 2: Haskell
=====================

The goal of this assignment is to do some financial programming in
Haskell, using Monads in the process.

Consider the following gamble.

You can bet some amount of money *x*.  A
[dreidel](https://en.wikipedia.org/wiki/Dreidel) is spun, with the
following highly nonstandard rules: if the dreidel comes up ג you
receive *10⋅x*,
otherwise you lose your bet of *x*.  Since there is a ¼ chance
of a ג, your expected return is *¼⋅10⋅x = 2.5⋅x*, so
your expected return is to more than double your bet.  This is a
gamble you *have* to take!

You start with an amount of money *y<sub>0</sub>*.  There are ten rounds of
play, each play you bet $p$ times however much money you have,
where *0 ≤ p ≤ 1*.

If you set *p = 1*, you are almost certain to lose all your money,
since the odds of winning all ten bets is 1 in 1,048,576, worse than
one in a million.  (Although if you *do* win all ten bets you'll end
up with an awful lot of money!)

If you set *p = 0*, you won't lose any money, but you also won't win
any money.

Your assignment is to:

* Use the Dist Monad (see Haskell/Dist.hs) to calculate the
  distribution of the amount of money you'll have if you start with a
  pot of *y<sub>0</sub>* and bet a fraction *p* of what you have, for *n* rounds.

    ````Haskell
    dreidelDreidelDreidel :: Double -> Double -> Int -> Dist Double
    dreidelDreidelDreidel y0 p n = ...
````

* Write a function
    ````Haskell
    mean :: Dist Double -> Double
    ````
	which calculates the mean value of a distribution of doubles.

	Example: ```mean $ Dist [(i,1/7) | i <- [0..6]]``` ↝ ```2.9999999999999996```

* Find (by plotting and trial and error to give a rough value, or by
  writing an optimization routine for some extra credit) a value of *p*
  which maximizes your expected return after *n=10* rounds of play
  starting with a pot of 1000, i.e., find *p* which maximizes
  ```mean (dreidelDreidelDreidel 1000 p 10)```.

* Let us define
    ````Haskell
    prExceeds :: Double -> Dist Double -> Double
    prExceeds target dist = mean $ fmap (fromIntegral . fromEnum . (>= target)) dist
    ````
	which calculates the probability of a sample from a distribution
	of Doubles meeting or exceeding ```target```.

    Example:
    ````
    $ ghci
	Prelude> :l Dreidel.hs
    *Dreidel> prExceeds 2000 $ dreidelDreidelDreidel 1000 0.5 10
    0.22412490844726563
    ````

	Find (again, by an optimization routine for extra credit) a value
	of *p* which maximizes the chance of having over 4000 after
	ten rounds of play starting with a pot of 1000, i.e., find *p*
	which maximizes ```prExceeds 4000 (dreidelDreidelDreidel 1000 p
	10))```.  What is this value of *p*?  What is the probability
	of ending up with over 4000 using that value of *p*?  What is the
	expected (i.e., mean) amount ended up with?

Newly Added Note
----------------

For a bit of extra credit, maximize the expected *log* return, and
compare this to the earlier maximization of the expected return.
Discuss.

What to turn in
---------------

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
Glossary
--------
###### Dreidel
![Dreidel Image]
(https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Dreidel_001.jpg/373px-Dreidel_001.jpg)
###### Spin the dreidel for gelt
![Spin the dreidel for gelt Image]
(http://www.desi.com.au/blog/wp-content/themes/desi.com/images/festive-time5.jpg)
###### [Heart-warming Story](http://www.timesunion.com/local/article/A-one-in-trillions-dreidel-game-2427950.php)
![Winning at Dreidel Image]
(http://ww2.hdnux.com/photos/07/42/02/1974401/3/920x920.jpg)
###### Hanukkah Menorah
![Hanukkah Menorah Image]
(https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Hanuka-Menorah-by-Gil-Dekel-2014.jpg/368px-Hanuka-Menorah-by-Gil-Dekel-2014.jpg)
###### Barack Lighting Hanukkah Candles
![Barack Lighting Hanukkah Candles Image]
(http://3.bp.blogspot.com/-rmlj6TQI9FI/TvF5ECIEK_I/AAAAAAAA1TM/kBz3m7Iq_i4/s1600/How+to+light+a+Hanukkah+menorah.jpg)
