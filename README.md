# hut

## nord bird
**gen commands**
  ``` hoon
  :hut|new [~per %hutopia] %huthut
  :hut|quit [~per %hutopia] %huthut
  :hut|join [~per %hutopia] %otherhut
  :hut|post [~per %hutopia] %huthut 'my important message'
  ```

  each command takes a `gid` and `name.hut`.


**new structure for hut**

by modifying %hut to use the sss library other structures for the state
make more sense than the current one. a major change is splitting the
state into two separate sss paths. one path `[%huts host.squad name.squad ~]`
includes a list of all the huts created by a squad, as well as a list of what
ship has joined what hut, and who from a squad is present in the hut app. the
second path `[%msgs name.hut ~]` holds all the msgs for a given hut, which should
be the second element of the path. (e.i. `[%msgs %huthut ~]`).

it's necessary to note that the concept of `=joined` in the new state structure
is very different from the original. in vanilla %hut `=joined` is meant for
the host of the huts to know the list of everyone who wants updates for
their huts. in the new state `=joined` is a list of ships in the squad
that have used sss to surf a hut and it's msgs. this is important
because the gossip protocol requires a known list of potential neighbors
for each available hut. ironically, I later added `=present` which is the jug
that `=joined` was originally. but the purpose for `=present` is to be
the list from which we construct our network, since it's possible that
not every member of your squad is using %hut.

here's an overview of the new state structure. squad members using %hut
will surf the `[%huts host.squad name.squad ~]` path, which will be common
among all members of the squad. lib/news will first assign gossip neighbors
based on their order in a list of all squad members (this requires getting a
little lucky). Each member is listening for new subscribers and will update the
list of `=present` ships. With every change in `=present` lib/news assigns new
neighbors forming the actually network.

the ui (when it's modified) will use the rock in the `[%huts ~.host %squad ~]`
path to generate the hut options. when a squad member chooses to `%join` a given
hut they will surf `[%msgs %that-hut ~]`. lib/news will use the list of `=joined`
ships to assign neighbors for gossiping that hut's msgs. any change in `=joined`
results in new neighbors being assigned.

just as a quick note on the improvement on the original state
structures. before, all the data for every hut was recorded in the state
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
