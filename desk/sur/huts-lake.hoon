/-  *hut
|%
++  name  %huts-lake
+$  rock  [=huts =joined]
+$  wave
  $%  [%new =hut =msgs our=@p]
      [%join =hut our=@p]
      [%quit =hut our=@p]
      [%del =hut our=@p]
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-  -.wave
    ::
      %new
    ~|  %cant-read-wut
    ?<  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      huts     (~(put ju huts.rock) squad.hut.wave name.hut.wave)
      ::  joined modifications
      ::  w/o a bowl, our is passed into the joined list for
      ::  the new hut we create
      joined   (~(put ju joined.rock) hut.wave our.wave)
    ==
  ::
      %del
    ?>  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      huts     (~(del ju huts.rock) squad.hut.wave name.hut.wave)
      joined   ~
    ==
    ::  a public record of who is interested in what hut
    ::  joined.rock will help determine neighbors for
    ::  individual hut gossiping
    ::
      %join
        :: a branch for init rock, otherwise read:pu-huts crashes on the
        :: assertion below
    ?:  =(rock *^rock)
      rock
    ?>  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      joined   (~(put ju joined.rock) hut.wave our.wave)
    ==
      %quit
    ?>  (~(has ju huts.rock) squad.hut.wave name.hut.wave)
    %=  rock
      joined   (~(del ju joined.rock) hut.wave our.wave)
    ==
  ==
--
::  types
::
::  +$  hut-act
::    $%  [%new =hut =msgs] :: may require passing our in poke, w/o
::                              joined no need for our=@p
::        [%post =hut =msg]
::        [%join =gid who=@p]
::        [%quit =gid who=@p]
::        [%del =hut]
::    ==
::  +$  gid  [host=@p name=@tas]
::  +$  hut      [=gid =name]
::  +$  msg      [who=@p what=@t]
::  +$  msgs     (list msg)
::
::
::  example pokes
::
::    in order to create a new squad, go to the localhost frontend
::      ready gid [~per %hutopia]
::      ready hut [[~per %hutopia] %huthut]
::    :hut &hut-do [[%huts ~] [%new [[~per %hutopia] %huthut] ~ our]]
::    :hut &hut-do [[%hut ~] [%post [[~per %hutopia] %huthut] [our 'what up?']]]
::    :hut &see ~
::    :hut &surf [~per [%hut ~]]
::    :hut &quit [~per [%hut ~]]
