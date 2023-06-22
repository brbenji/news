/-  *hut, *squad, huts-lake, msgs-lake
/+  default-agent, dbug, agentio, *sss, news, verb
::
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          sub_huts=_(mk-subs:sss huts-lake sss-paths)  :: /huts/squad
          pub_huts=_(mk-pubs:sss huts-lake sss-paths)
          sub_msgs=_(mk-subs:sss msgs-lake sss-paths)  :: /msgs/hut
          pub_msgs=_(mk-pubs:sss msgs-lake sss-paths)
      ==
    +$  card  card:agent:gall
    --
::
=|  state-0
=*  state  -
::
=<  %-  agent:dbug
    %+  verb  &
    ^-  agent:gall
    |_  bowl=bowl:gall
    +*  this  .
        def   ~(. (default-agent this %.n) bowl)
        io    ~(. agentio bowl)
        hc    ~(. +> [bowl ~])
        nw  ~(. news bowl)
        su-huts  =/  da  (da huts-lake sss-paths)
                (da sub-huts bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        pu-huts  =/  du  (du huts-lake sss-paths)
                (du pub-huts bowl -:!>(*result:du))
    ::
        su-msgs  =/  da  (da msgs-lake sss-paths)
                (da sub-msgs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        pu-msgs  =/  du  (du msgs-lake sss-paths)
                (du pub-msgs bowl -:!>(*result:du))
    ::
    ++  on-init
      ^-  (quip card _this)
      :_  this
      :~  (~(watch-our pass:io /squad) %squad /local/all)
      ==
    ::
    ++  on-save  !>(state)
    ::
    ++  on-load
      |=  =vase
      ^-  (quip card _this)
      =/  old  !<(versioned-state vase)
      ?-  -.old
        %0  `this(state old)
      ==
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      ?+    mark  `this
        ::
        ::  :hut &huts [[%new [[~per %hutopia] %huthut] ~ our]]
        ::  :hut &huts [[%quit [[~per %hutopia] %huthut] our]]
        ::  :hut &huts [[%join [[~per %hutopia] %huthut] our]]
        ::  :hut &huts [[%del [[~per %hutopia] %huthut] our]]
          %huts
        ::  attempting to pull thru a $hut-act and add the our to the waves here
        =/  act  !<(wave.huts-lake vase)
        ~&  act
        ?+    -.act
          ~_  %hut-doesnt-exist
          ?>  (~(has ju huts.rock.pub) gid.hut.act name.hut.extract)
          =^  cards  pub-huts
            (give:pu-huts [%huts gid.hut.act ~] act)
          [cards this]
            %post  ~_  %try-post-mark  !!
          ::
            %new
          ~_  %hut-already-exists
          ?<  (~(has ju huts.rock) gid.hut.wave name.hut.wave)
          =^  cards  pub-huts
            (give:pu-huts [%huts gid.hut.act ~] [act our.bowl])
          =^  cardz  pub-msgs
            (give:pu-msgs [%msgs name.hut.act ~] [hut.extract *msg])
          [(weld cards cardz) this]
            ::  join
            ::    surf a [msgs hut ~] path from your neighbor
            %join
          ~_  %hut-doesnt-exist
          ?>  (~(has ju huts.rock.pub) gid.hut.act name.hut.extract)
       ::   ::
       ::   ::  join a hut for it's msgs
       ::   ::    surf appropriate msgs path
       ::   ::    give:pu-huts =joined our ship for that hut
       ::   ::
       ::   ::  :hut &join [[~per [%msgs %huthut ~]] [%join [[~per %hutopia] %huthut] our]]
       ::   ::
       ::   ::    XX: why not use the name.hut already in the wave.huts-lake and
       ::   ::    remove the [%msgs ~] path
       ::      %join
       ::    =/  new-sub-msgs
       ::      (surf:su-msgs !<(@p (slot 4 vase)) %hut !<([%msgs name.hut ~] (slot 5 vase)))
       ::    ~&  >  "sub-msgs is: {<read:su-msgs>}"
       ::    ::
       ::    =/  new-pub-huts
       ::      (give:pu-huts [[%huts ~] !<(wave.huts-lake (slot 3 vase))])
       ::    ~&  >  "pub-huts is: {<read:pu-huts>}"
       ::    ::
       ::    =/  deck-o-cards
       ::      (weld -.new-sub-msgs -.new-pub-huts)
       ::    :-  deck-o-cards
       ::    %=  this
       ::      sub-msgs  +.new-sub-msgs
       ::      pub-huts  +.new-pub-huts
       ::    ==
       ::      =^  cards  pub-huts
       ::        (give:pu-huts [%huts gid.hut.act ~] act)
       ::      [cards this]
       ::
        ::
        ::  :hut &post [[[~per %hutopia] %huthut] [our 'what up?']]
          %post
        =/  act  !<(wave.msgs-lake vase)
        ~|  %be-yourself
        ?>  =(our.bowl who.msg.act)
        ~|  %missing-hut
        =/  pub  (need (~(get by read:pu-huts) [%huts ~]))
        ~&  rock.pub
        ::  only do stuff with huts that exist
        ::
        ~|  %missing-hut
        ?>  (~(has ju huts.rock.pub) gid.hut.act name.hut.extract)
        ::  XX: make sure the hut named in the pub path also exists in =huts
        ::      probably, check that our name is in the =joined list too.
        ::
        =/  path  [%msgs name.hut.act ~]
        =^  cards  pub-msgs
          (give:pu-msgs path act)
        ~&  >  "pub-msgs is: {<read:pu-msgs>}"
        [cards this]
        ::
        ::  :hut &quit [~zod [%*]]
          %quit
        =.  sub-huts
          (quit:su-huts !<(@p (slot 2 vase)) %hut !<([%huts ~] (slot 3 vase)))
        ~&  >  "sub-huts is: {<read:su-huts>}"
        `this
        ::
      ::
          %sss-on-rock
        ::  `[src=ship from=dude =rock:lake wave=(unit wave:lake)]`
        ?-    msg=!<($%(from:su-huts from:su-msgs) (fled vase))
            [[%huts ~] *]
          =/  path  %huts
          ?<  ?=([%crash *] rock.msg)
          ::
          ~&  >>  rock.msg
          ~&  >>>  wave.msg
          ::
          ::  pub also needs to be empty, before we decide to copy.
          ::  ?: &(=(wave.msg ~) =(rock-huts ~))
          ?@  wave.msg
            ::  copy if we aren't publishing [%huts ~]
            ?:  (~(has by read:pu-huts) [path ~])
              `this
            =.  pub-huts  (copy:pu-huts sub-huts [src.msg dap:bowl [path ~]] [path ~])
            ~&  >  "pub-huts is: {<read:pu-huts>}"
            `this
          ~&  "has in pu-huts {<(~(has by read:pu-huts) [path ~])>}"
          =/  wave  (need wave.msg)
          ::  check if the rock is exactly like our last rock
          =/  rock-huts  (need (~(get by read:pu-huts) [path ~]))
          ::  check if the key.rock.msg is way more advantaged by
          ::  seeing if we adding the existing waves to our rock, would we
          ::  still be less than the key in msg.
          ::  if so we should copy their state.
          ::
          ::  ?:  (lth (add wave.rule key.rock.rock-huts) key.rock.msg)
          ::      (copy
          ~&  >  "rock-huts hash: {<(mug rock.rock-huts)>} vs rock.msg hash: {<(mug rock.msg)>}"
          ?:  =((mug rock.rock-huts) (mug rock.msg))
            ~&  >  %this-is-our-wave
            ::  rocks are same, so just don't
            `this
          ::
          ?+  -.wave  `this
                %allow
            ~&  >>  %allow-branch
            =/  sub  (need (~(get by read:su-huts) [src.msg dap:bowl [path ~]]))
            =/  allowed  ~(tap in (~(get ju allowed.rock.sub) squad.wave))
            =.  pub-huts  (secret:pu-huts [path ~]~)
            =.  pub-huts  (allow:pu-huts allowed [path ~]~)
            ::  publish it!
            ::
            =^  cards  pub-huts
              (give:pu-huts [path ~] wave)
            [cards this]
                %new
            =/  pub  (need (~(get by read:pu-huts) [%huts ~]))
            ::  if our pub hasn't set any allowed ships, do that.
            ~&  "allowed.pub {<allowed.pub>}"
            ?~  allowed.pub
              ::  a brand new subscription needs to be copyied, made secret, and set perms
              =/  sub  (need (~(get by read:su-huts) [src.msg dap:bowl [path ~]]))
              =/  allowed  ~(tap in (~(get ju allowed.rock.sub) gid.hut.wave))
              =.  pub-huts  (secret:pu-huts [path ~]~)
              =.  pub-huts  (allow:pu-huts allowed [path ~]~)
              ~&  >  "pub-huts is: {<read:pu-huts>}"
              ::
              ~|  %hut-already-exists
              ?<  (~(has ju huts.rock.pub) gid.hut.wave name.hut.wave)
              ::  stitch wave into our own pub
              =^  cards  pub-huts
                (give:pu-huts [path ~] wave)
              [cards this]
            ::
            ~|  %hut-already-exists
            ?<  (~(has ju huts.rock.pub) gid.hut.wave name.hut.wave)
            ::  stich wave into our own pub
            =^  cards  pub-huts
              (give:pu-huts [path ~] wave)
            [cards this]
          ==
        ::
            [[%msgs *] *]
          `this
        ==
      ::
          %sss-to-pub
        ?-  msg=!<($%(into:pu-huts into:pu-msgs) (fled vase))
            [[%huts ~] *]
          ~&  >>  %to-pub
          ~&  "msg: {<msg>}"
          =^  cards  pub-huts  (apply:pu-huts msg)
          [cards this]
        ::
            [[%msgs *] *]
          =^  cards  pub-msgs  (apply:pu-msgs msg)
          [cards this]
        ==
        ::
        ::  =^  cards  pub-huts
        ::    (give:pu-huts [%huts ~] [%allow [[our.bowl squad.act] ~(tap in members)]])
        ::  =.  pub-huts  (secret:pu-huts [%huts ~]~)
        ::  =.  pub-huts  (allow:pu-huts ~(tap in members) [%huts ~]~)
        ::  ~&  >  "pub-huts is: {<read:pu-huts>}"
        ::  [cards this]
          %sss-huts-lake
        ::  ~&  >>  %sss-huts-lake
        =/  msg  !<(into:su-huts (fled vase))
        ~&  >>>  "sss-huts-lake msg: {<!<(into:su-huts (fled vase))>}"
        ~&  >>  "type: {<type:msg>}"
        ::
        ::  +$  pubs  [%0 (map paths buoy)]
        ::  +$  tide  :: basically bouy
        ::    $:  rok=((mop aeon rock:lake) gte)
        ::        wav=((mop aeon wave:lake) lte)
        ::        rul=rule
        ::        mem=(mip ship dude @da)
        ::    ==
        ::  =/  rock-huts  (~(get by +.pub-huts) [%huts ~])
        ::  ~&  >>  "rock-huts: {<(~(get by +.pub-huts) [%huts ~])>}"
        ::  =/  tide  tid:(need rock-huts)
        ::  =/  waves  wav.+.tide
        ::  =/  wavon  ((on @ud wave.huts-lake) lte)
        ::  ::  pull out the wav mop, bap into a reverse list, and snag the highers wave
        ::  =/  current-wave-aeon  key:(snag 0 (bap:wavon waves))
        ::  ~&  >>>  "first of the bap: {<current-wave-aeon>}"
        ::  ::
        ::  =/  rock  rok.-.tide
        ::  ~&  "rock in tide: {<rock>}"
        ::  ?~  rock  `this ::  XX: not a great branch
        ::  =/  rokon  ((on @ud rock.huts-lake) gte)
        ::  ::  =/  current-rock-aeon  key:(snag 0 (tap:rockon rock))
        ::  ::  ~&  >>>  "first of the tap: {<current-rock-aeon>}"
        ::  ::  ~&  >>  "wav.pub-huts: {<(bap:wavon waves)>}"
        ::  =/  new  (get:wavon waves aeon:msg)
        ::  ~&  >>  "do I have this aeon?: {<(get:wavon waves aeon:msg)>}"
        ::
        =^  cards  sub-huts
          (apply:su-huts !<(into:su-huts (fled vase)))
        ?+    type.msg  [cards this]
          ::  use scry as a trigger to determine which neighbor to copy
          ::  and potentially see if there will be waves we need to ignore
          ::  (looking at the wave:rule)
            %scry
          ~&  >>>  "incoming aeon: {<aeon:msg>}"
          [cards this]
        ==  ::type.msg
        ::
          %sss-msgs-lake
        =^  cards  sub-msgs  (apply:su-msgs !<(into:su-msgs (fled vase)))
        ::  ~&  >  "sub-huts is: {<read:su-huts>}"
        [cards this]
        ::
          %sss-surf-fail
        =/  msg  !<($%(fail:su-huts fail:su-msgs) (fled vase))
        ::  ?-  msg
        ::  [[%huts ~] ~]
        ::    if a surf-fails pick a (new) small-world neighbor
        ::    but be sure to keep your natural neighbor
        ::
        ::    (small-world:nw members)
        ::
        ::  can I tell if a neighbor is offline or not?
        ::  |hi neighbor
        ~&  >>>  "not allowed to surf on {<msg>}!"
        `this
      ==
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ::   why are these here from sss simple?
      ::  ?>  ?=(%poke-ack -.sign)
      ::  ?~  p.sign  `this
      ::  %-  (slog u.p.sign)
      ?+    wire   `this
      ::  "give me a call" -publisher
          [~ %sss %scry-request @ @ @ %huts @tas ~]
        =^  cards  sub-huts  (tell:su-huts |3:wire sign)
        [cards this]
      ::
          [~ %sss %scry-request @ @ @ %msgs @tas ~]
        =^  cards  sub-msgs  (tell:su-msgs |3:wire sign)
        [cards this]
      ::
          [~ %sss %on-rock @ @ @ %huts @tas ~]
        =.  sub-huts  (chit:su-huts |3:wire sign)
        `this
      ::
          [~ %sss %on-rock @ @ @ %msgs @tas ~]
        =.  sub-msgs  (chit:su-msgs |3:wire sign)
        `this
      ::
          [%squad ~]
        ?+    -.sign  (on-agent:def wire sign)
            %kick
          :_  this
          :~  (~(watch-our pass:io /squad) %squad /local/all)
          ==
            %watch-ack
          ?~  p.sign  `this   :: success
          :_  this
          :~  (~(wait pass:io /behn) (add now.bowl ~m1))  ::try again
          ==
          ::
            %fact
          ?>  ?=(%squad-did p.cage.sign)
::          +$  upd
::            $%  [%init-all =squads =acls =members]
::                [%init =gid =squad acl=ppl =ppl]
::                [%del =gid]
::                [%allow =gid =ship]
::                [%kick =gid =ship]
::                [%join =gid =ship]
::                [%leave =gid =ship]
::                [%pub =gid]
::                [%priv =gid]
::                [%title =gid =title]
::            ==
          =/  =upd  !<(upd q.cage.sign)
          ?+    -.upd  (on-agent:def wire sign)
              ::  new squad  [%init =gid =squad acl=ppl =ppl]
              ::    make new hut with (give [%hut gid.upd ~])
              ::    set public or private based on pub.squad.upd (pub=?)
              ::    if public use acl to (block acl.upd)
              ::    if private just us ppl.upd to set (allowed ppl.upd)
              ::      we'll add any new members thru %join upd
              %init
              ::  a squad has been deleted
              ::    (kill [%huts gid.upd ~]) and kill all related msgs paths
              ::    turn over (~(get ja huts) gid.upd) (kill [%msgs hut ~]
              %del
              ::  someone is out of the squad. recalculate subs?
              ?(%kick %leave)
              ::  new member. recalculate subs?
              %join
              ::  convert [%huts squad ~] to public
              %pub
              ::  convert [%huts squad ~] to private
              %priv

              %init-all
            ::  you just watched the local/all path
            ::  establish the your publications based on the squad info
            ::  exactly what &hacky-init did but legit
            ::
            =^  pub-dek  pub-huts
              ?:  pub.squad.upd
                  :: public: don't make (secret) but do (block acl.upd)
              :: privat: make (secret) and (allow path ppl.upd)
              ::
              ::  turn (give:pu-huts [%huts squad.upd ~] [[%new gid.squad.upd hut?
              ::    wait this isn't a new hut, it's only a possible
              ::    path, to be made public/secret and set the blocked
              ::    or allowed? what am I supposed to do?
              ::
::                =^  cards  pub-huts
::                  (give:pu-huts [%huts ~] [%allow [[our.bowl squad.extract] ~(tap in members)]])
::                =.  pub-huts  (secret:pu-huts [%huts ~]~)
::                =.  pub-huts  (allow:pu-huts ~(tap in members) [%huts ~]~)
::                ~&  >  "pub-huts is: {<read:pu-huts>}"
::                [cards this]
            ::  use the list of members for each squads to surf your neighbor
            ::
            =/  squads  ~(tap in ~(key by squads.upd))
            ~&  "GO! my favorite sports team!: {<squads>}"
            ?~  squads  `this
            ::
            =/  index  0
            =/  deck=(list card)  ~
            =/  subs  sub-huts
            |-
            ?:  =(index (lent squads))
               [deck this]
            =/  squad  (snag index squads)
            =/  members  ~(tap in (~(get ju members.upd) squad))
            ~&  "members for {<squad>} are {<members>}"
            ?:  =((lent members) 1)
              ~&  %only-you-in-squad
              $(index +(index))
            =/  neighbor  (assign:nw members)
            ~&  "your neigbor is {<(assign:nw members)>}"
            =^  cards  sub-huts
              (surf:su-huts neighbor dap.bowl [%huts squad ~])
            $(index +(index), deck (weld deck cards), subs sub-huts)
        ::  ::
        ::  ::  %msgs path needs to exist before settings perms
        ::  =.  pub-msgs  (secret:pu-msgs [%msgs name.hut.act ~]~)
        ::  =.  pub-msgs  (allow:pu-msgs allowed [%msgs name.hut.act ~]~)
        ::    ::
        ::    ::  :hut &surf-huts [[~per %hutopia] ~per]
        ::      %surf-huts
        ::    ~&  >>  %one
        ::    ~&  >>  %surf-huts
        ::    =/  act  !<([squad=gid neighbor=@p] vase)
        ::    ::
        ::    ~|  %surfing-self
        ::    ?<  =(neighbor.act our.bowl)
        ::    ::
        ::    ~|  %already-subbed
        ::    ?<  (~(has by read:su-huts) [neighbor.act %hut [%huts ~]])
        ::    =^  cards  sub-huts
        ::      (surf:su-huts neighbor.act %hut [%huts ~])
        ::    [cards this]
          ==  :: %fact mark
        ==  ::  %squad sign
      ==  ::  wire
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card _this)
      ?+    wire  `this
          [~ %sss %behn @ @ @ %huts @tas ~]  [(behn:su-huts |3:wire) this]
          [~ %sss %behn @ @ @ %msgs @tas ~]  [(behn:su-msgs |3:wire) this]
      ==
    ++  on-peek  on-peek:def
    ++  on-watch  on-watch:def
    ++  on-leave  on-leave:def
    ++  on-fail  on-fail:def
    --
::
|_  [bol=bowl:gall dek=(list card)]
+*  that  .
++  emit  |=(=card that(dek [card dek]))
++  emil  |=(lac=(list card) that(dek (welp lac dek)))
++  abet
  ^-  (quip card _state)
  [(flop dek) state]
::
--
