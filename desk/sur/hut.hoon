:: first we import the type definitions of
:: the squad app and expose them
::
/-  *squad
|%
:: nord - added for expanding huts to a dynamic number of paths
:: /huts/squad  allow squad whitelist to see the collection of chat rooms
:: /msgs/hut  allow squad whitelist that is appropriate for each hut
::
++  sss-paths  ,[@tas @tas ~]
:: an individual chat message will be a pair
:: of the author and the message itself as
:: a string
::
+$  msg      [who=@p what=@t]
:: an individual hut will contain an ordered
:: list of such messages
::
+$  msgs     (list msg)
:: the name of a hut
::
+$  name     @tas
:: the full identifier of a hut - a pair of
:: a gid (squad id) and the name
::  +$  gid  [host=@p name=@tas]
::
+$  hut      [=gid =name]
:: huts will be how we store all the names
:: of huts in our state. It will be a map
:: from gid (squad id) to a set of hut names
::
+$  huts     (jug gid name)
:: this will contain the messages for all huts.
:: it's a map from hut to msgs
::
+$  msg-jar  (jar hut msg)
:: this tracks who has actually joined the huts
:: for a particular squad
::
:: nord - converted gid to hut now I just want to
:: know who joined what hut, so I can pick a neighbor
::
+$  joined   (jug hut @p)
:: this is all the actions/requests that can
:: be initiated. It's one half of our app's
:: API. Things like creating a new hut,
:: posting a new message, etc.
::
+$  hut-act
  $%  [%new =hut =msgs]
      [%post =hut =msg]
      [%join =hut who=@p]
      [%quit =hut who=@p]
      [%del =hut]
  ==
:: this is the other half of our app's API:
:: the kinds of updates/events that can be
:: sent out to subscribers or our front-end.
:: It's the $hut-act items plus a couple of
:: additional structure to initialize the
:: state for new subscribers or front-ends.
::
+$  hut-upd
  $%  [%init =huts =msg-jar =joined]
      [%init-all =huts =msg-jar =joined]
      hut-act
  ==
--
