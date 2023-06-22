# hut

## nord bird
**reasoning this out**
  starting from nothing. our app is aware of potential paths that
  contain identical lakes. there are two sets of potential paths to two
  distinct lakes. one is the collection of huts for a given squad as well as
  who has joined which hut. the second is the msgs for each specific
  hut.
    the huts-lake is meant for everyone within a squad to surf, so they can
    decide which hut to join. joining a hut requires looking up who's
    joined the hut and surf one of those ship's [msgs that-hut ~] path.
  when the app "wakes up" the first time. it watches it's squad app to
  be informed of every squad they are apart of, as well as receive
  updates to changes. the first thing to do is take the list of squads
  and members and subscribe to our assigned neighbor. (if we are the
  only one, we should publish a bunt of the lake and set pub/secret, and
  perms. for public, block the acl list. for secret, allow ourselves.)

  if the surf fails, we should probably publish our own bunt of the lake
  and try to surf a small-world neighbor encase our natural-neighbor is
  offline and not coming back.
    this small-world neighbor searching could occur indefinitely until
    someone is found online in the network....wait if our natural
    neighbors are derived from the members of squad there is a big
    disconnect. those members might not be on huts. and we can't rely on
    them to ever come online...can that possibly matter for this
    capstone? if it does, then we need a second jug of =joined in
    rock.hut-lake. the original =joined will function how it was
    originally intended and tell who in the squad is using huts. the
    new =msgs-joined will be a (jug hut @p).
    but doesn't this effect my intiation process, if we can't pretend to
    rely on the squad members list then we have no idea who to first
    subscribe to...and we're back to my original plan. I suppose having
    the original %hut =joined set would become a refining mechanism once
    our small-world connection actually gets a hit. but feeding two
    different list of ships to get different natural-neighbors is just
    confusing.
  let's just make the assumption that every member of a squad is using
  %huts. maybe it's a suite of apps that pseudo-walled-garden urbit dev
  has created and all apps are downloaded as agents within one desk.

  how can I make this as dumb as possible?
    accept the naive concept of sending all the state of a specific
    huts/squad/, including all msgs for all chats that ship isn't
    interested in. the frontend can choose to display it or not. given
    the efficiency of sss transfer, maybe this is okay. besides, if our
    lib/news can accept a normal state (or pieces of it) and gossip it
    around automatically using sss. that is a workthwhile library.
  what are the ins and outs of lib/news if manages every aspect of sss
  for us automatically and can be given a standard state (in whole or
  portion) to be gossiped?
    let's say the state (or portion) is handed to the library. it will
    need to generate the lakes necessary to hold that state, the waves
    that changes it and the washes that define that change. (here is the
    first issue. I don't believe we can programmatically define the
    washes from...well we would derive it from the pokes.) waves are
    easier, it would generally be hut-act or something.
    maybe we can take the core which accepts those hut-act (+local) and
    feed that the act into it. (can a library call app core arms?) would
    I need to pass in this to the library. we're probably approaching
    wrapper agent territory where we need to created virtual arms to
    live within the gall:agent.
  wrapper-agent library (example dbug)
    looks to me like the wrapper agent is a gall:agent itself whose
    virtual arm is the terminal gall:agent. the wrapper-agent will be
    the first to injest cages, wire sign, paths, etc in all the agent
    arms. it will determine if it ought to do something based on that
    input. sometimes it will engage exclusively with the input, but
    often it passes the input into the agent's matched arm and produces
    the result.
    this could be a clean way of wrapping sss around an agent.
    interesting, dbug is what receives the bowl and it passes it down
    into the terminal agent.
  an sss-wrapper-agent that can gossip
    rapid brain-storming, all the boilerplate pokes, dude, and peeks
    would be easier than writing them in. plus processing gossip things
    like we do in sss-on-rock poke would be uninstrusive and probably
    universal. the state plugged into a lake, might be simple. the waves
    can still be pulled from /sur...wait that means I'd need to import
    that sur file /-. it should be cool. looking at verb, we can pass in
    other things besides the agent.
    (ex: in dbug we can %-(agent:dbug [act= your-agent]) or
      %-  agent:dbug  :-  act=
      ... ) and within dbug the agent arm should be a wet gate |* now.
    we'll probably need to explicitly pass in the state too, or whatever
    we want to gossip.
    (ex: =*  state  -
         %-  agent:dbug  :-  actions=  :-  [=huts =joined]
         ...)  in the wrapper-agent  gate  |*  [act=* state=* agent:gall=*]
    now with the state, actions, and interconnection with the terminal
    agent our wrapper-agent may be able to generate a lake as well as
    utilize the actual arms to implement a wash.
    for a lake, the name can be generic for news (along with it's
      mar/sss/news.hoon file.)
    the rock will easily be the passed in state.
    waves can be the passed in actions.
    and washes will need to be...my thinking is vague here, but we can
    pass pokes that match our actions type into the on-poke:ag (or at
    least what isn't a poke for sss stuff), and see what kind of [this]
    comes out. the returned [this] could be our washes output rock. (if
    we're only given a portion of the state, how can we make sure we
    only pull that portion out of the returned [this]?
    ps. we also pass along any cards.
  what about paths?
    we can probably assume a base path of [%news ~], since sss takes
    into account the app name too. and we should probably accept an
    optional [refinement= ] argument or [secondary-paths= ] which allows
    the user to define an input or I guess type that can me be second
    path with news [%news %seconary ~]. wait this isn't making sense?
    what would I pass into the agent? for %hut we first need to receive
    the squad info to have a list of secondary-paths. we get this
    on-agent. and not only that but the secondary-paths can change. they
    need different permissions and to be able to be killed.
    how would we seamlessly recieve this secondary-paths list?
    first if we are consistently fed the full list of secondary-paths
    (i.e. a list of squads) and everytime we account for the diff in
    that list for creating or killing pubs.
    but again weirdly here's our parochial problem, we want to set the
    perms based on the secondary info (squads), I guess that info would
    need to passed in with each secondary path.
  ++  secondary-paths  :: to handle changes to specific paths beyond state
    here we go: we need more arms (++ secondary-paths)
    what all would this arm need as an input in order to produce sss
    actions like (allow:pu [%news secondary ~] (list ships)) :: we need
    list ships.  same for (block:pu . . .)
    or (kill:pu [%news secondary ~])  :: so list of secondaries to turn
    a kill.
    (public:pu path), (secret:pu path)
    so |=  [pub= acl=]  :: to borrow the elegance of squad

    also notice how we'll need to define our door pu and su to make these
    calls into lib/sss. where should that be? probably in a core
    composed before the arms ++ agent arm and ++ secondary-paths.
    one thing I never quite understood was how to create these paths,
    what is necessary to begin publishing? is (allow) or (block) enough?
    usually I consider (give:pu) as the creation, but give only delivers
    a wave. (and isn't needed here in this arm.)
  handling surfing
    the decision to surf would be handled by an arm that would receive
    an appropriate (list ship) that are apart of the network. for %huts
    this would be =joined.
    this will take the list, assign a neighbor (or new one), perform an
    appropriate (surf:su) and or (quit:su).
    if the surf fails our a flag for stale is created, we should seek
    for a small-world neighbor as well, but that will be handled
    (+small-world called from sss-surf-fail and wherever a stale is
    seen). again they (quit:su) and (surf:su) that small-world neighbor.
**next**

  **sequence of a wave entering the network**

  OUR OWN INTEREST for GETTING PUB INFO  -  behn timer activated sequences
    %hut: on-arvo on wire //sss/behn/~pet/hut/29/huts, [%behn %wake]  (behn:su-huts wire sign)
        (hidden: if we are interested, we scry our neighbor) `?:  (lte aeon aeon:(fall (~(got by sub) ship dude path) *flow))`
    %hut: on-agent on wire //sss/scry-request/~pet/hut/29/huts, %poke-ack  (tell:su-huts wire sign) < stale flag
        (can I haz next aeon?)
        %hut: on-poke with mark %sss-surf-fail
    %hut: on-poke with mark %sss-huts-lake  (apply:su-huts type=%nigh) > set behn

  A NEW WAVE COMING IN
    %hut: on-poke with mark %sss-huts-lake  (apply:su-huts type=%scry what=%wave wave...)
        (first view of aeon. apply will both scry and poke us)
    %hut: on-poke with mark %sss-on-rock  (copy & secret & allow & give)
    %hut: on-agent on wire //sss/on-rock/29/~pet/hut/huts, %poke-ack  (chit:su-huts wire sign) < fail flag

  LISTENING TO OUR SUBSCRIBERS
    %hut: on-poke with mark %sss-to-pub   (apply:pu-huts when=[~ 30])
    %hut: on-agent on wire //sss/scry-response/~per/hut/30/huts, %poke-ack



with squad watching now on the table, the need for multiple paths, and needing
to put whatever I can into the lib/news (like what's under sss-on-rock).
it could very well be time to just write it all again. using my agent as a
reference.

~pet has a different rock hash from the other two after a nuke.
this is because it didn't set the allowed ships.
  (even though way I'm doing allowed ships right now that's getting boogus).
  (I'm subbed to %squad now. so that should be my source.)
  (I also need to make a new path for each squad for the allow list to match.)
  (I should also make the private/public settings for squad and sss
  responsive to each other...squad->sss)
that's because it never received a wave.msg, which is the only places we set
allowed ships for sss.
so this lack of allowed ships in the state, can occur at every wave.rule step (5)
I suppose for the branch under wave.msg is ~ and I copy. we could also check for
allowed/perms on sss. if nill. we do that hole thing...
(but I'm less motivated now I know it's so wrong.)
(looks like I'm doing a big state overhaul. maybe it's time to rewrite?)


on-agent will handle the surfing, (and quiting if we figure that out. no quiting.)
what about sss-surf-fail. (small-world:nw )
  (chit:su-huts) might also be useful, it flags a fail when sss-on-rock, nacks
  maybe a better trigger for (small-worlda:nw) is if =stale or =fail are %.y

sss-on-rock needs more checks for dual neighbors
  this can probably move into lib/news. we can pass in msg and our pub.
  msg doesn't contain the aeon, but the path it comes on does...not sure how to
  see that besides verb &
  [bingo! I'm pretty sure the on-agent wire sss/on-rock/... will contain the aeon

dynamic neighbors and a squad subscriptions is necessary for hut to work as I
see it. on-init can watch %squad for all squads we are apart of (does return
on-agent). then use that info to watch each of those squad's member list.
on-agent will receive the latest list of members, and any changes in the member
list. for either instance the whole list is sent to lib/news +assign to return
a natural neighbor to surf their %huts. this will establish the complete list
of possible hut-chat-rooms our ship can join.

dual neighbors and bad-neighbors.
I don't know how to determine if a surf is unsuccessful, but if I can then we
should be given a random small-world neighbor (which can change as many times
as needed to succeed). the small-world neighbor will be surfed too. for this to
work well we'll need more checks in sss-on-rock. but first know that our pub is
our state, that will be our source of truth until a better truth is heard. and
at that point we will make our pub like that.
the first new check is before copying. right now, we copy when we receive an
empty wave.msg, but we need to `add AND when our pub is empty too`. this way we
won't wipe our truth with a neighbor that is fresh to the network (which can
happen when a new member joins and they are sorted to the right of us in the
list). after that check we'll need to start comparing rock key numbers before
we check if our rocks have the same hash (because if we don't have the same hash
we could end up knitting in the same set of waves we just did, throwing us way
off). we only bother handling the wave.msg if the rock.msg has a higher key
number than our own. (thought: is it possible we can get a neighbor so advanced
that we'll accept their waves because their key is gth ours but adding their
waves won't catch us up. yes.) we should probably add a check for how our rock
key compares to the wave rule. if (add wave.rule our.key.rock) is lth (lte?)
key.rock.msg then we should copy their state into our pub. (this happens when
we've been offline for too long.

key points:
 - we need more checks to make dual-neighbors work.
 - small-world...it looks like I'm letting the network choose how the rewiring
 connected-ness works on it's own based on bad neighbor activity.

 natural-neighbor vs small-world-neighbor
 one thing worth noting is that the natural-neighbor shouldn't be dropped
 because if no-one is listening to them their posts are out of the network. so
 natural-neighbors (ships right of you on a list) will stay connected to at all
 times, but for the sake of robust-ness if we can detect a bad-neighbor we will
 add a second small-world-neighbor at random which can be changed as often as
 needed.

**known issues**
  - sss allowed list only is at the path level. for it to be refined enough to
  reflect every squad's whitelist, a new path for each squad would need to be
  created. (I'll also run into this issue when it comes to [%msgs name.hut ~]
  paths. this is out of the scope of the capstone imo.) creating a path dynamically
  might be possible but I don't know how I'd execute it. (I'd copy linedb)

**test**  three ships ~per, ~sun, ~pet
  **per revived**
    - we setup a hefty state in hut and passed it around the network
    - the ~per (the og agent) was nuked
    - ~per re-subbed to ~pet
    - ~per caught up flawlessly
    - only hitch: ~sun now has a stale=%.y flag. not sure how to flip it back.
  **non-%allow wave wash**
    - the allowed list for pubs can be set alongside the %allow wave in %sss-on-rock
    - but if a collection of waves didn't contain an %allow wave there is another way
    - in %new branch, there's a check for allow.pub and if it's nill it runs
    the secret and allow stuff. based on what is in sub.
    - ~pet was nuked
    - ~per produced 6 %new huts (to fill the wave collection)
    - ~pet subs to ~per
    - works great!
  **aeon leap test**
    - first per will publish huts
    - sun will subscribe per
    - sun will copy that sub into an identical pub
    - pet will subscribe to sun
    - sun will receive several waves from per then copy again
    - q: what happens to pet?
      conjecture: sss will flip out because the key value of sun pub rock will
      jump in value
    - sun copied per after the key value went from 7 to 10
    - ans: wrong! sss handles the jump just fine. but is that safe enough?
        why would it not be safe?
    perhaps this means the state verification is fine, lib/news should focus on
    quality neighbors.
  **middle-man addition test**
    - with per publishing huts
    - have sun change something in that state path
    - pet ought to receive that wave fine
    - q: what happens to sun's subscription with per?
      - conjecture: nothing happens. that subsciption stays fine, and when sun copies
      the sub to per. it will simply erase its own work and per might have
      problems.
    - ans: conjecture was correct. but a disconnection issue arises for pet.
      because sun wipes its own wave when it copies per's new wave, pet doesn't
      know what to do so it keeps the last update from sun. (this has sun's
      addition, while sun has opted to only hold onto per's latest publication.)
    - in someway, sun would be better off not blindly copying per's pub. but when
    new waves come in, it should simply apply them to it's own publication.
    copying is reserved for initialization of surf/join and potentially in special
    gossip problem scenarios as a backdoor.

**pomo**
  PROCESS for pet and per:
  - per create a squad called `%hutopia`
  - per makes the squad private and white lists desired members
  - each member `|install ~per %squad` opens app and joins `~per/hutopia`
  - pet `:hut &surf-huts [~per ~[%huts]]`
  - pet `:hut &copy [~per %huts]`
  - per `:hut &surf-huts [~pet ~[%huts]]`
  - pet and per should both be able to create new huts and the other should see it
  - per `:hut &hut-do [[%huts ~] [%new [[~per %hutopia] %huthut] ~ our]]`

**notes**
  searching for where the aeon is incremented in lib/sss
  - inc +() is used in
    - du +give, +live, +read, +apply, +form x2
    - da +surf, +apply %scry
  - add is used in
    - +form is used in du +rule, +wipe, and +give
    - behn timer stuff
  - du +latest poops an aeon
    - new notes inside that func
    - used and incremented in du +give, and +apply
  - +copy is still very promising with modifications

**the real work**  start creating the lib/news that assigns neibhors and
determines when a state is new or not, and whether it should be
gossiped. it should receive squad members and =joined ships somehow to
determine the neighbors based on rules. it should connect with sss to
manage who subs who and how to manage gossiped pubs based on the
validity of a received pub.

**new structure for hut**
by modifying %hut to use the sss library other structures for the state
make more sense than the current one. a major change is splitting the
state into two separate sss paths. one path `[%huts ~]` includes a list of
all the huts created by a squad, as well as a list of what ship has
joined what hut. the second path `[%msgs *]` holds all the msgs for a
given hut, which should be the second element of the path. (e.i. `[%msgs
%huthut ~]`).

it's necessary to note that the concept of `=joined` in the new state structure
is very different from the original. in vanilla %hut `=joined` is meant for
the host of the huts to know the list of everyone who wants updates for
their huts. in the new state `=joined` is a list of ships in the squad
that have used sss to surf a hut and it's msgs. this is important
because the gossip protocol requires a known list of potential neighbors
for each available hut.

here's an overview of the new state structure. squad members using %hut
will surf the `[%huts ~]` path, which will be common among all members
of the squad. lib/news will randomize all the squad ships to determine
neighbors for gossiping. the ui will use the rock in the `[%huts ~]` path to
generate the hut options. when a squad members chooses to `%join` a
given hut they will surf `[%msgs %that-hut ~]`. lib/news will use the
list of `=joined` ships to assign neighbors for gossiping that hut's
msgs.

just as a quick note on the improvement on the original state
structures. before all the data for every hut was recorded in the state
of the host in a jug of msgs per hut. and ontop of that the host had to
keep track of interested ships to properly send updates. now each ship
takes care of their own subscriptions by `%join`ing and `%quit`ing with
sss. and instead of the host keeping all of the chat data, that data is
stored only by the interested ships. it's just nice :)

## Desk

The desk currently has the minimum amount of files necessary to distribute an application and should be distributable immediately. Any further Hoon development should happen here.

TODO: Add further documentation on beginning Hoon development

## UI

hut is built primarily using [React], [Typescript], and [Tailwind CSS]. [Vite] ensures that all code and assets are loaded appropriately, bundles the application for distribution and provides a functional dev environment.

### Getting Started

To get started using hut first you need to run `npm install` inside the `ui` directory.

To develop you'll need a running ship to point to. To do so you first need to add a `.env.local` file to the `ui` directory. This file will not be committed. Adding `VITE_SHIP_URL={URL}` where **{URL}** is the URL of the ship you would like to point to, will allow you to run `npm run dev`. This will proxy all requests to the ship except for those powering the interface, allowing you to see live data.

Your browser may require CORS requests to be enabled for the use of `@urbit/http-api`. The following commands will add `http://localhost:3000` to the CORS registry of your ship

```bash
~zod:dojo> +cors-registry

[requests={~~http~3a.~2f.~2f.localhost ~~http~3a.~2f.~2f.localhost~3a.3000} approved={} rejected={}]

~zod:dojo> |cors-approve ~~http~3a.~2f.~2f.localhost~3a.3000

~zod:dojo> +cors-registry

[requests={~~http~3a.~2f.~2f.localhost} approved={~~http~3a.~2f.~2f.localhost~3a.3000} rejected={}]

~your-sig:dojo>
```

Regardless of what you run to develop, Vite will hot-reload code changes as you work so you don't have to constantly refresh.

### Deploying

To deploy, run `npm run build` in the `ui` directory which will bundle all the code and assets into the `dist/` folder. This can then be made into a glob by doing the following:

1. Create or launch an urbit using the -F flag
2. On that urbit, if you don't already have a desk to run from, run `|merge %work our %base` to create a new desk and mount it with `|mount %work`.
3. Now the `%work` desk is accessible through the host OS's filesystem as a directory of that urbit's pier ie `~/zod/work`.
4. From the `ui` directory you can run `rsync -avL --delete dist/ ~/zod/work/hut` where `~/zod` is your fake urbit's pier.
5. Once completed you can then run `|commit %work` on your urbit and you should see your files logged back out from the dojo.
6. Now run `=dir /=garden` to switch to the garden desk directory
7. You can now run `-make-glob %work /hut` which will take the folder where you just added files and create a glob which can be thought of as a sort of bundle. It will be output to `~/zod/.urb/put`.
8. If you navigate to `~/zod/.urb/put` you should see a file that looks like this `glob-0v5.fdf99.nph65.qecq3.ncpjn.q13mb.glob`. The characters between `glob-` and `.glob` are a hash of the glob's contents.
9. Now that we have the glob it can be uploaded to any publicly available HTTP endpoint that can serve files. This allows the glob to distributed over HTTP.
10. Once you've uploaded the glob, you should then update the corresponding entry in the docket file at `desk/desk.docket-0`. Both the full URL and the hash should be updated to match the glob we just created, on the line that looks like this:

```hoon
    glob-http+['https://bootstrap.urbit.org/glob-0v5.fdf99.nph65.qecq3.ncpjn.q13mb.glob' 0v5.fdf99.nph65.qecq3.ncpjn.q13mb]
```

11. This can now be safely committed and deployed.

[react]: https://reactjs.org/
[typescript]: https://www.typescriptlang.org/
[tailwind css]: https://tailwindcss.com/
[vite]: https://vitejs.dev/
