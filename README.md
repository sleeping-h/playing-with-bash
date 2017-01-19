# playing-with-bash
definetly wrong way of using bash

####   2048.sh
everyone knows this game :)

a tiny console version

![](http://i.imgur.com/kEfwyHQ.png)  

move: _w a s d_, exit: _q_

####   arkanoid.sh
simple ascii version

unfortunately bash doesn't support floats <br>
and available cursor positions are also <br>
integer and discret, so "physics" is very rough

![](http://i.imgur.com/oih7cCX.png)  

move: a d, exit: q

####   dragon_curve.sh
draws a fractal using L-systems
```
     _   _
   _| |_|_|          _
  |_    |_   _      | |_
         _|_|_|        _|
        |_|_|_   _   _|_
         _|_| |_|_|_| |_|
        |_|_    |_|_
          |_|     |_|
```
up to 10 iterations
