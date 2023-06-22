/-  sss :: probably need this
=>
  |%
  +$  neighbors  (list ship)
  +$  neighbor  ship
  ++  card  card:agent:gall
  ++  sss-paths  ,[@tas @tas ~]
  --
::
++  agent
  |*  [act=* state=* =agent:gall]
  =>
    |%
    ++  lake
      |%
      ++  name  %news
      +$  rock  state
      +$  wave  act
      ++  wash
        |=  [=rock =wave]
        ^+  rock
        rock  ::  our wash effect will occur when we detect a wave act
              ::  this will be given to the terminal agent (on-poke:ag act)
              ::  to transform the state for us. then we'll simply
              ::  produce that version of the rock. *is this crazy?
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          subs=_(mk-subs:sss lake sss-paths)  :: /huts/squad
          pubs=_(mk-pubs:sss lake sss-paths)
      ==
  =|  state-0
  =*  state  -
  ^-  agent:gall
  =<
    |_  =bowl:gall
    +*  this  .
        ag    ~(. agent bowl)
        hc   ~(. +> bowl)
        su  =/  da  (da lake sss-paths)
            (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        pu  =/  du  (du lake sss-paths)
            (du pubs bowl -:!>(*result:du))
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent
        ?+    -.mark

          :: default
          ::  !<(act vase)  :: should we be testing type somehow? make
                            ::  sure we won't pass along a transformed
                            ::  state we aren't aware of. I guess we
                            ::  could make a list of head-tags from act
                            ::  and ... not sure
          :: SHAKING MY HEAD "yeah. I don't think this works."
          ::  as a subscriber we'd be waiting to be given a wave. if we
          ::  get a wave what do we do with it? we'd plug it into our
          ::  wash and just produce the rock we're given.
          ::
          ::  so maybe this works for our own personal collection of
          ::  actions and getting our standard state up in sss form, but
          ::  I can't see how this works with the pub-sub model.
          ::  let's go back to our original.
          (on-poke:ag mark vase)
        ::  sss boilerplate
        ::
            %sss-news
          =^  cards  subs  (apply:su !<(into:su (fled:sss vase)))
          [cards this]
        ::
            %sss-to-pub
          =+  msg=!<($%(into:pu) (fled:sss vase))
          =^  cards  pubs  (apply:pu msg)
          [cards this]
        ::
            %sss-surf-fail
          =/  msg  !<(fail:su (fled:sss vase))
          ~&  >>>  "not allowed to surf on {<msg>}"
          `this
        ::
            %sss-on-rock  :: a rock has updated
          =+  !<([p=path src=@p @ ? ? *] vase)
          ?>  ?=([@ @ ~] p)  ::  TODO: is this true?
          =*  repo-path=path
            /repo-updates/(scot %p src)/[i.p]
          =*  branch-path=path  [(scot %p src) p]
          :_  this
          :_  ~
          :^  %give  %fact
            ~[repo-path [%branch-updates branch-path]]
          :-  %linedb-update
          !>(`update`[%new-data branch-path])
        ==
      [cards this]
    ::
    ++  on-peek
      |=  =path
      ^-  (unit (unit cage))
      (on-peek:ag path)
    ::
    ++  on-init
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  on-init:ag
      [cards this]
    ::
    ++  on-save   on-save:ag
    ::
    ++  on-load
      |=  old-state=vase
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-load:ag old-state)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-watch:ag path)
      [cards this]
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-leave:ag path)
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-agent:ag wire sign)
      [cards this]
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-arvo:ag wire sign-arvo)
      [cards this]
    ::
    ++  on-fail
      |=  [=term =tang]
      ^-  (quip card:agent:gall agent:gall)
      =^  cards  agent  (on-fail:ag term tang)
      [cards this]
    --
  |_  =bowl:gall
  ++  mk-paths
    |=  secondary=@tas
    ^-  path:sss
    [%news secondary ~]
  ++  secondary-paths
    |=  [paths=(list @tas) pub=? acl=(list ship)]
    ^-  (quip card _+.state)
    ::  based on input set given paths to (public/secret) (block/allow)
    ::  (kill) any path...we need state? because we don't know if a list
    ::  of paths is different from the previous without state.
    ::  can't I (read:pu) and see? I'll make state for sss like usual
    =/  paths  (turn ^paths mk-paths)
    ?:  pub
      (block:pu acl paths)
    =.  pubs  (secret:pu paths)
    =.  pubs  (allow:pu acl paths)
    `+.state
  ++  assign
      ::  any change in the on-agent subscription to the host's squad, will
      ::  result in a new calculation of neighbors.
      ::
        |=  =neighbors
        ^-  neighbor
        =/  our  (need (find [our.bowl]~ neighbors))
        ::  if we are at the end of the list, grab the first ship
        ?:  (gte +(our) (lent neighbors))
          (snag 0 neighbors)
        :: select our right neighbor
        (snag +(our) neighbors)
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
  --
--
::  dbug: agent wrapper for generic debugging tools
::
::    usage: %-(agent:dbug your-agent)
::
|%
+$  poke
  $%  [%bowl ~]
      [%state grab=cord]
      [%incoming =about]
      [%outgoing =about]
  ==
::
+$  about
  $@  ~
  $%  [%ship =ship]
      [%path =path]
      [%wire =wire]
      [%term =term]
  ==
--
::
