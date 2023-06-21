/-  sss :: probably need this
=>
  |%
  +$  neighbors  (list ship)
  +$  neighbor  ship
  ++  card  card:agent:gall
  --
::
::  pu-doors=(list @t) su-doors=(list @t)
::  |_  [bowl=bowl:gall group=* =neighbors]
|_  =bowl:gall
::  random duplicate neighbors
::
++  small-world
  :: it's quite possible the most reasonable thing to do is let the
  :: network decide for itself how dense of a small-world it want to be.
  :: it can do this by requesting a small-world neighbor anytime it
  :: encounters issues.
  ::
  |=  net=(list ship)
  ::  calc total number of nodes n
  =/  n  (lent net)
  ::  how many duplicate neighbors? based on log(n)
  =/  dups  (xeb n)
  ::  randomly select lucky ships
  =/  index  0
  =/  bloop  0
  |-
  ?:  =(index dups)
    bloop
  $(index +(index), bloop +(bloop))
  :: don't try to surf yourself
  :: =(our.bowl rando-neighbor) try again?
  ::
::  any change in the on-agent subscription to the host's squad, will
::  result in a new calculation of neighbors.
::
++  assign
  |=  =neighbors
  ^-  neighbor
  =/  our  (need (find [our.bowl]~ neighbors))
  ::  if we are at the end of the list, grab the first ship
  ?:  (gte +(our) (lent neighbors))
    (snag 0 neighbors)
  :: select our right neighbor
  (snag +(our) neighbors)
::
::  surf ought to be automatically triggered once neighbors are assigned
::    do I assign with the full squad list? or only those actually
::    connecting?
::    bc neighbors should be dynamic (for loses and changes) the
::    original assignment should always be based on a dynamic list, not
::    just the whole squad list.
::      (the static squad list, is only adequate for setting the allowed
::      list)
::
++  surf-neighbors
  ::  probably not a card for poking ourself, most likely just producing
  ::  what will is needed to surf...or maybe just the assignment is all
  ::  I need.
  ::
  ::  ^-  card
  ~
--
