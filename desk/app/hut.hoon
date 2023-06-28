/-  *hut, *squad, huts-lake, msgs-lake
/+  default-agent, dbug, agentio, *sss, news, verb
::
|%
+$  card  card:agent:gall
--
::
%-  agent:dbug
%+  verb  |
::
=/  sub-huts  (mk-subs huts-lake ,[%huts @ta @tas ~])
=/  pub-huts  (mk-pubs huts-lake ,[%huts @ta @tas ~]) ::  /huts/~per/hutopia
::
=/  sub-msgs  (mk-subs msgs-lake ,[%msgs name.hut ~])
=/  pub-msgs  (mk-pubs msgs-lake ,[%msgs name.hut ~])
::
^-  agent:gall
::
=<
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    io    ~(. agentio bowl)
    nw  ~(. news bowl)
    nest    ~(. +> bowl)
    su-huts  =/  da  (da huts-lake ,[%huts @ta @tas ~])
            (da sub-huts bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    pu-huts  =/  du  (du huts-lake ,[%huts @ta @tas ~])
            (du pub-huts bowl -:!>(*result:du))
::
    su-msgs  =/  da  (da msgs-lake ,[%msgs name.hut ~])
            (da sub-msgs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    pu-msgs  =/  du  (du msgs-lake ,[%msgs name.hut ~])
            (du pub-msgs bowl -:!>(*result:du))
::
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  (~(watch-our pass:io /squad) %squad /local/all)
  ==
::
++  on-save  !>([sub-huts pub-huts sub-msgs pub-msgs])
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =/  old  !<([=_sub-huts =_pub-huts =_sub-msgs =_pub-msgs] vase)
  :-  ~
  %=  this
    sub-huts  sub-huts.old
    pub-huts  pub-huts.old
    sub-msgs  sub-msgs.old
    pub-msgs  pub-msgs.old
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  `this
  ::
  ::  :hut &hut-do [[%new [[~per %hutopia] %huthut] ~ our]]
  ::  :hut &hut-do [[%quit [[~per %hutopia] %huthut] our]]
  ::  :hut &hut-do [[%join [[~per %hutopia] %huthut] our]]
  ::  :hut &hut-do [[%pres [~per %hutopia] [our]~]]
      %hut-do
    =/  act  !<(wave.huts-lake vase)
    ~&  act
    ?-    -.act
        %pres  `this  :: %pres doesn't have a hut.
      ::
        %quit
      =/  path  ~[%huts (scot %p host.squad.hut.act) name.squad.hut.act]
      =^  cards  pub-huts
        (give:pu-huts path act)
      =.  pub-msgs  (kill:pu-msgs [%msgs name.hut.act ~]~)
      [cards this]
      ::
        %new
      =/  path  ~[%huts (scot %p host.squad.hut.act) name.squad.hut.act]
      =/  members  ~(tap in (scry-for-members:nest squad.hut.act))
      =/  pub  (need (~(get by read:pu-huts) path))
      ~_  %hut-already-exists
      ::  checking hut existence here fixes a bug when this occurs in wash
      ::
      ?<  (~(has ju huts.rock.pub) squad.hut.act name.hut.act)
      ::  publish the new hut as well as the start of its msgs
      ::
      =^  cards  pub-huts
        (give:pu-huts path act)
      =.  pub-huts  (secret:pu-huts [path]~)
      =.  pub-huts  (allow:pu-huts members [path]~)
      ::
      =^  cardz  pub-msgs
        (give:pu-msgs [%msgs name.hut.act ~] [hut.act [who.act 'first!']])
      =.  pub-msgs  (secret:pu-msgs [%msgs name.hut.act ~]~)
      =.  pub-msgs  (allow:pu-msgs members [%msgs name.hut.act ~]~)
      [(weld cards cardz) this]
      ::
        %join
      =/  path  ~[%huts (scot %p host.squad.hut.act) name.squad.hut.act]
      =/  msgs-path  [%msgs name.hut.act ~]
      ::    only try to join what exists
      ::
      =/  rock-huts  (need (~(get by read:pu-huts) path))
      =/  prev-joined  (~(get ju joined.rock.rock-huts) hut.act)
      ::
      ?~  prev-joined
        ~&  >>>  %no-such-hut  `this
      ::
      =/  add-self  (~(put in (~(get ju joined.rock.rock-huts) hut.act)) who.act)
      =/  joined  ~(tap in add-self)
      =/  neighbor  (assign:nw joined)
      ~&  >  "your msg-neighbor is {<neighbor>} "
      =/  members  ~(tap in (scry-for-members:nest squad.hut.act))
      ::
      =^  cards  sub-msgs
        (surf:su-msgs neighbor dap.bowl [%msgs name.hut.act ~])
      ::
      =^  cardz  pub-huts
        (give:pu-huts path act)
      [(weld cards cardz) this]
      ::
    ==
  ::
  ::  :hut &post [[[~per %hutopia] %huthut] [our 'what up?']]
      %post
    =/  act  !<(wave.msgs-lake vase)
    =/  path  [%msgs name.hut.act ~]
    ~_  %be-yourself
    ?>  =(our.bowl who.msg.act)
    ::  only do stuff with huts that exist
    ::
    =/  huts-path  ~[%huts (scot %p host.squad.hut.act) name.squad.hut.act]
    ~_  %missing-hut
    =/  pub  (need (~(get by read:pu-huts) huts-path))
    ~_  %missing-hut
    ?>  (~(has ju huts.rock.pub) squad.hut.act name.hut.act)
    ::
    =^  cards  pub-msgs
      (give:pu-msgs path act)
    [cards this]
  ::
  ::  :hut &see ~
  ::  opt :hut &see [~per %hutopia]
      %see
    ?~  q.vase
      ~&  >  "pub-huts is: {<read:pu-huts>} hash {<(mug read:pu-huts)>}"
      ~&  >  "sub-huts is: {<read:su-huts>}"
      ~&  >  "pub-msgs is: {<read:pu-msgs>}"
      ~&  >  "sub-msgs is: {<read:su-msgs>}"
      `this
    =/  gid  !<(=gid vase)
    ~&  >  "scry-for-members: {<(scry-for-members:nest gid)>}"
    `this
  ::
        %sss-on-rock
    =/  msg  !<($%(from:su-huts from:su-msgs) (fled vase))
    ~&  "msg sss-on-rock: {<msg>}"
    ?-    msg
        [[%huts *] *]
      =/  host  &2.path.msg
      =/  name  &3.path.msg
      =/  path  [%huts host name ~]
      ::
      =/  rock-huts  (~(get by +.pub-huts) path)
      =/  wave  (need wave.msg)
      ::  check if the rock is exactly like our current rock
      =/  rock-huts  (need (~(get by read:pu-huts) path))
      ?:  =((mug rock.rock-huts) (mug rock.msg))
      ~&  >  %this-is-our-wave
        `this
      ::
      ?-    -.wave
          %pres
        =^  cards  pub-huts
          (give:pu-huts path wave)
        [cards this]
        ::
          %new
        =/  pub  (need (~(get by read:pu-huts) path))
        ~_  %hut-already-exists
        ?<  (~(has ju huts.rock.pub) squad.hut.wave name.hut.wave)
        ::  stich wave into our own pub
        =^  cards  pub-huts
          (give:pu-huts path wave)
        [cards this]
        ::
          %quit
        =/  pub  (need (~(get by read:pu-huts) path))
        ~_  %hut-doesnt-exists
        ?>  (~(has ju huts.rock.pub) squad.hut.wave name.hut.wave)
        ::  stich wave into our own pub
        =^  cards  pub-huts
          (give:pu-huts path wave)
        [cards this]
        ::
          %join
        =/  pub  (need (~(get by read:pu-huts) path))
        =/  msgs-path  [%msgs name.hut.wave ~]
        ::  are we in this hut?
        =/  join-at-path  (~(get ju joined.rock.pub) hut.wave)
        ?:  (~(has in join-at-path) our.bowl)
          =/  add-joined  (~(put in (~(get ju joined.rock.pub) hut.wave)) who.wave)
          =/  joined  ~(tap in add-joined)
          =/  neighbor  (assign:nw joined)
          ~&  >  "your msg-neighbor is {<neighbor>} "
          ::
          =^  cardz  sub-msgs
            (surf:su-msgs neighbor dap.bowl [%msgs name.hut.wave ~])
          ::
          =^  cards  pub-huts
            (give:pu-huts path wave)
          [(weld cards cardz) this]
        ::
        =^  cards  pub-huts
          (give:pu-huts path wave)
        [cards this]
      ==
    ::
        [[%msgs *] *]
      =/  hut  &2.path.msg
      =/  path  [%msgs hut ~]
      =/  wave  (need wave.msg)
      =/  rock-msgs  (~(get by read:pu-msgs) path)
      ::  check if we are publishing
      ?:  |(=(rock-msgs ~) =(rock-msgs *wave.msgs-lake))
        :: we aren't publishing this so, first copy
        =/  members  ~(tap in (scry-for-members:nest squad.hut.wave))
        =.  pub-msgs  (copy:pu-msgs sub-msgs [src.msg dap:bowl path] path)
        =.  pub-msgs  (secret:pu-msgs [path]~)
        =.  pub-msgs  (allow:pu-msgs members [path]~)
        `this
      =/  rock-msgs  (need rock-msgs)
      ::  check if the rock is exactly like our current rock
      ?:  =((mug rock.rock-msgs) (mug rock.msg))
        ~&  >  %this-is-our-msg
        `this
      ::
      =^  cards  pub-msgs
        (give:pu-msgs path wave)
      [cards this]
    ==
  ::
      %sss-to-pub
    ?-  msg=!<($%(into:pu-huts into:pu-msgs) (fled vase))
        [[%huts *] *]
      =^  cards  pub-huts  (apply:pu-huts msg)
      [cards this]
    ::
        [[%msgs *] *]
      =^  cards  pub-msgs  (apply:pu-msgs msg)
      [cards this]
    ==
  ::
      %sss-huts-lake
    =/  msg  !<(into:su-huts (fled vase))
    =^  cards  sub-huts
      (apply:su-huts !<(into:su-huts (fled vase)))
    ?+    type.msg  [cards this]
        %scry
      ~&  >>>  "incoming aeon: {<aeon:msg>}"
      [cards this]
    ==  ::type.msg
  ::
      %sss-msgs-lake
    =^  cards  sub-msgs  (apply:su-msgs !<(into:su-msgs (fled vase)))
    [cards this]
  ::
      %sss-surf-fail
    =/  msg  !<($%(fail:su-huts fail:su-msgs) (fled vase))
    ~&  >>>  "not allowed to surf on {<msg>}!"
    `this
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire   `this
      [~ %sss %scry-request @ @ @ %huts @ta @tas ~]
    =^  cards  sub-huts  (tell:su-huts |3:wire sign)
    [cards this]
  ::
      [~ %sss %scry-request @ @ @ %msgs @tas ~]
    =^  cards  sub-msgs  (tell:su-msgs |3:wire sign)
    [cards this]
  ::
      [~ %sss %on-rock @ @ @ %huts @ta @tas ~]
    =.  sub-huts  (chit:su-huts |3:wire sign)   :: potentiall fail flag
    `this
  ::
      [~ %sss %on-rock @ @ @ %msgs @tas ~]
    =.  sub-msgs  (chit:su-msgs |3:wire sign)   :: potential fail flag
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
      =/  =upd  !<(upd q.cage.sign)
      ?+    -.upd  `this
          %init   :: a new squad
        =/  squad  gid.upd  :: yeah. my renaming of gid to squad is causing probs
        =/  path  [%huts (scot %p host.squad) name.squad ~]
        =/  members  ~(tap in ppl.upd)
        ~&  "members for {<squad>} are {<members>}"
        =/  neighbor  (assign:nw members)
        ~&  "your neigbor is {<(assign:nw members)>}"
        ::
        =^  cards  sub-huts
          (surf:su-huts neighbor dap.bowl path)
        =^  cardz  pub-huts
          (give:pu-huts path [%pres squad [our.bowl]~])
        =.  pub-huts  (secret:pu-huts [path]~)
        =.  pub-huts  (allow:pu-huts members [path]~)
        [(weld cards cardz) this]
        ::
          ?(%kick %leave) :: someone is out of the squad. remove
        `this
        ::
          %join   :: someone joined the squad. add them to the allowed list.
        `this
        ::
          %pub  :: squad is made public. (public) scry for asl?
        `this
        ::
          %priv :: squad is made private
        `this
        ::
          %init-all
        ::  use the list of squads (gid)s to surf your neighbor for each squad
        ::
        =/  squads  ~(tap in ~(key by squads.upd))
        ~&  "GO! my favorite sports team!: {<squads>}"
        :: loop over each squad
        ::
        =/  index  0
        =/  deck=(list card)  ~
        =/  subs  sub-huts
        =/  pubs  pub-huts
        |-
        ?:  =(index (lent squads))
           [deck this]
        =/  squad  (snag index squads)
        =/  path  [%huts (scot %p host.squad) name.squad ~]
        =/  members  ~(tap in (~(get ju members.upd) squad))
        ?:  =((lent members) 1)
          ~&  %only-you-in-squad
          $(index +(index))
        ~&  "members for {<squad>} are {<members>}"
        =/  neighbor  (assign:nw members)
        ~&  "your neigbor is {<(assign:nw members)>}"
        ::
        =^  cards  sub-huts
          (surf:su-huts neighbor dap.bowl path)
        =^  cardz  pub-huts
          (give:pu-huts path [%pres squad [our.bowl]~])
        =.  pub-huts  (secret:pu-huts [path]~)
        =.  pub-huts  (allow:pu-huts members [path]~)
        %=  $
          index  +(index)
          deck  (weld deck (weld cards cardz))
          subs  sub-huts
          pubs  pub-huts
        ==
      ==  :: %fact mark
    ==  ::  %squad sign
  ==  ::  wire
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  wire  `this
    [~ %sss %behn @ @ @ %huts @ta @tas ~]  [(behn:su-huts |3:wire) this]
    [~ %sss %behn @ @ @ %msgs @tas ~]  [(behn:su-msgs |3:wire) this]
  ==
++  on-peek  on-peek:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-fail  on-fail:def
--
::
|_  bol=bowl:gall
++  scry-for-members
  |=  =gid
  .^  ppl
    %gx
    (scot %p our.bol)
    %squad
    (scot %da now.bol)
    %members
    (scot %p host.gid)
    /[name.gid]/noun
  ==
--
