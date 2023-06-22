:: first we import the type defs from /sur/hut.hoon
::
/-  *hut
:: our mark door takes a $hut-upd as its argument
::
|_  u=hut-upd
:: grow handles conversions from our %hut-did mark to other
:: marks. We'll be sending updates out to the front-end, so
:: we need conversion methods to JSON in particular
::
++  grow
  |%
  :: we handle a plain noun by just returning the $hut-upd
  ::
  ++  noun  u
  :: here are the conversion methods to JSON
  ::
  ++  json
    :: we expose the contents of the enjs:format library so we
    :: don't have to type enjs:format every time we use its
    :: functions
    ::
    =,  enjs:format
    :: we return a $json structure
    ::
    |^  ^-  ^json
    :: we switch on the type of $hut-upd and JSON-encode it
    :: appropriately. For each case we create an object with
    :: a single key corresponding to the update type, and containing
    :: another object with its details
    ::
    ?-    -.u
        %new
      %+  frond  'new'
      (pairs ~[['hut' (en-hut hut.u)] ['msgs' (en-msgs msgs.u)]])
    ::
        %post
      %+  frond  'post'
      (pairs ~[['hut' (en-hut hut.u)] ['msg' (en-msg msg.u)]])
    ::
        %join
      %+  frond  'join'
      (pairs ~[['gid' (en-gid gid.u)] ['who' s+(scot %p who.u)]])
    ::
        %quit
      %+  frond  'quit'
      (pairs ~[['gid' (en-gid gid.u)] ['who' s+(scot %p who.u)]])
    ::
        %del
      (frond 'del' (frond 'hut' (en-hut hut.u)))
    ::
        %init
      %+  frond  'init'
      %-  pairs
      :~  ['huts' (en-huts huts.u)]
          ['msgJar' (en-msg-jar msg-jar.u)]
          ['joined' (en-joined joined.u)]
      ==
    ::
        %init-all
      %+  frond  'initAll'
      %-  pairs
      :~  ['huts' (en-huts huts.u)]
          ['msgJar' (en-msg-jar msg-jar.u)]
          ['joined' (en-joined joined.u)]
      ==
    ==
    :: this function creates an array of the the members of a the
    :: huts for a squad
    ::
    ++  en-joined
      |=  =joined
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by joined)
      |=  [=gid =ppl]
      %-  pairs
      :~  ['gid' (en-gid gid)]
          :-  'ppl'
          a+(sort (turn ~(tap in ppl) |=(=@p s+(scot %p p))) aor)
      ==
    :: this function creates an array of all the messages for all
    :: the huts
    ::
    ++  en-msg-jar
      |=  =msg-jar
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by msg-jar)
      |=  [=hut =msgs]
      (pairs ~[['hut' (en-hut hut)] ['msgs' (en-msgs msgs)]])
    :: this function creates an array of all the metadata for
    :: all huts
    ::
    ++  en-huts
      |=  =huts
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by huts)
      |=  [=gid names=(set name)]
      %-  pairs
      :~  ['gid' (en-gid gid)]
          ['names' a+(turn (sort ~(tap in names) aor) (lead %s))]
      ==
    :: encode an array of all the messages in a particular hut
    ::
    ++  en-msgs  |=(=msgs `^json`a+(turn (flop msgs) en-msg))
    :: encode an individual chat message
    ::
    ++  en-msg
      |=  =msg
      ^-  ^json
      (pairs ~[['who' s+(scot %p who.msg)] ['what' s+what.msg]])
    :: encode a hut id
    ::
    ++  en-hut
      |=  =hut
      ^-  ^json
      (pairs ~[['gid' (en-gid gid.hut)] ['name' s+name.hut]])
    :: encode a squad id
    ::
    ++  en-gid
      |=  =gid
      ^-  ^json
      (pairs ~[['host' s+(scot %p host.gid)] ['name' s+name.gid]])
    --
  --
:: grab handles conversion methods from other marks to our mark.
::
++  grab
  |%
  :: we just handle the normal noun case by molding it with the
  :: $hut-upd type
  ::
  ++  noun  hut-upd
  --
:: grad handles revision control functions. We don't need to deal with
:: these so we delegate them to the %noun mark
::
++  grad  %noun
--
