/-  sss :: probably need this
=>
  |%
  +$  neighbors  (list ship)
  +$  neighbor  ship
  ++  card  card:agent:gall
  --
::
|_  =bowl:gall
::
++  assign
  |=  =neighbors
  ^-  neighbor
  =/  our  (find [our.bowl]~ neighbors)
  ?~  our
    =/  rando  (~(rad og eny.bowl) (lent neighbors))
    (snag rando neighbors)
  ::  if we are at the end of the list, grab the first ship
  ?:  (gte +((need our)) (lent neighbors))
    (snag 0 neighbors)
  :: select our right neighbor
  (snag +((need our)) neighbors)
::
::  UNIMPLEMENTED
::  random second neighbor
::
++  small-world
  |=  net=(list ship)
  ::  calc total number of nodes n
  =/  n  (lent net)
  ::  how many duplicate neighbors? based on log(n)
  =/  dups  (xeb n)
  ::  randomly select lucky ships
  =/  index  0
  =/  bloop  0  :: XX: bloop should use ~(rad og in a way that generates a new
                ::     number for each dups
  |-
  ?:  =(index dups)
    bloop
  $(index +(index), bloop +(bloop))
--
