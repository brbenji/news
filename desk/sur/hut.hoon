/-  *squad
|%
+$  msg      [who=@p what=@t]
+$  msgs     (list msg)
+$  name     @tas
::  nord - naming a gid as squad for easier reading
::
+$  hut      [squad=gid =name]
+$  huts     (jug gid name)
+$  msg-jar  (jar hut msg)
:: nord - converted gid to hut now I just want to
:: know who joined what hut, so I can pick a neighbor
::
+$  joined   (jug hut @p)
+$  present   (jug squad=gid @p)
::
+$  hut-act
  $%  [%new =hut =msgs]
      [%post =hut =msg]
      [%join =hut who=@p]
      [%quit =hut who=@p]
      [%del =hut]
  ==
::
+$  hut-upd
  $%  [%init =huts =msg-jar =joined]
      [%init-all =huts =msg-jar =joined]
      hut-act
  ==
--
