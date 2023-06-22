/-  *hut
|%
++  name  %msgs-lake
+$  rock  [=hut =msgs]
+$  wave  [=hut =msg]
++  wash
  |=  [=rock =wave]
  ^+  rock
    ::  check the length of msgs in state
  ?.  (lte 50 (lent msgs.rock))
    ::  if less than 50 append new msg to msgs list
    [hut.wave [msg.wave msgs.rock]]
  ::  if more than 50 append new msg after snipping the end of msgs list
  [hut.wave [msg.wave (snip msgs.rock)]]
::  [hut=[squad=[host=@p name=@tas] name=@tas] msgs=it([who=@p what=@t])]
--
::  XX:
::  [x] try to get this dual state of huts and msgs compiling
::  [ ] think thru how a subscriber would see what %huts are available,
::  and attempt to subscribe to the appropriate [%msgs hut ~] path
