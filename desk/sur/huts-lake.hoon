/-  *hut
|%
++  name  %huts-lake
+$  rock  [=huts =joined =present]
+$  wave
  $%  [%new =hut =msgs who=@p]    ::  nord - added who to poke. lake doesn't have our.bowl
      [%join =hut who=@p]
      [%quit =hut who=@p]
      [%pres squad=gid ships=(list @p)]
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-  -.wave
      %new
    ~_  %hut-already-exists
    ?<  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      huts     (~(put ju huts.rock) squad.hut.wave name.hut.wave)
      joined   (~(put ju joined.rock) hut.wave who.wave)
    ==
    ::
      %join
    ?:  =(rock *^rock)
      rock
    ?>  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      joined   (~(put ju joined.rock) hut.wave who.wave)
    ==
    ::
      %quit
    ~_  %hut-doesnt-exists
    ?>  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    ::
    =/  left  (need (~(get by joined.rock) hut.wave))
    ?.  =(1 ~(wyt in left)) ::  last one
      %=  rock
        joined   (~(del ju joined.rock) hut.wave who.wave)
      ==
    ::  turn the lights off when you're the last one out
    ~&  >>>  "goodbye {<name.hut.wave>}"
    %=  rock
      huts     (~(del ju huts.rock) squad.hut.wave name.hut.wave)
      joined   (~(del ju joined.rock) hut.wave who.wave)
    ==
    ::
      %pres
    =/  gate  (cury |=([squad=gid ship=@p] [squad ship]) squad.wave)
    =/  jug-list  (turn ships.wave gate)
    %=  rock
      present  (~(gas ju present.rock) jug-list)
    ==
  ==
--
