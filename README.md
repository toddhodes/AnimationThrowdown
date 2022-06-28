
Animation Throwdown scripts


These scripts 
- get your deck card inventory, and Combo Mastery, and output it as text
- allow you to automate adventure and arena fights
- allow you to automate purchasing

## Setup

### User info

To do API calls to kongregate, you need your player ID and password hash.  You can get these
by turning on the "Developer Console" in your web browser, and investigating some of the traffic
while playing the game. This is the *same info* you use to register with Zbot; the user ID is your
player ID, visible in your player detail card.  Asking about this in the Line messaging 
app in your guild's channel (see `https://line.me/`) as if you're using ZBot is the easiest way to get help on this.

Once you have these, add them to a file called `.at_creds` in your home directory (`~/.at_creds`),
formatted as follows:

```
user_id=8679305
password_hash=6BhhkA23C47ED572
```

replacing those values with those matching your account.

I'll add more details on this later.


### Mac software dependencies

You'll need a few programs you may not have installed yet.  Run this:

```
brew install curl XMLStarlet jq
```



## Generate card inventory and combo mastery

### Run this in your Terminal app:

In the directory where you cloned this, simply run
```
make
```

and that's it!  It does the rest for you.  If this doesn't work for you, open an issue, happy to help.

### Sample output

Here's some sample output, edited to be shorter; you can see my complete card
set as generated by these scripts here:

https://raw.githubusercontent.com/toddhodes/AnimationThrowdown/master/Decks/CARDS

and simiarly the combo masteries as generated by the scripts here:

https://raw.githubusercontent.com/toddhodes/AnimationThrowdown/master/Combos/ComboMastery

Here are excerpts, highlighting how the epic/legendary/mythic and fused level display, and, 
how CM level and CM stones are shown combined together:

*Decks/CARDS:*

First column is number of cards with that exact level fusing.  Second column is Rare/Epic/Legendary/Mythic.  Third Column is card name.  Fourth column is the level of fusing.  Fusing takes 5 levels for epics, 6 for legendaries, and 7 for mythics.  e.g., this shows 
2 max-fused epic Cute Witch of the North,
2 max-fused legnedary Cute Witch of the North,
10 max-fused legendary Zapp character cards,
and a max-fused Mythic Zapp.

```
   2 E Cute Witch of the North: 5**
   4 L Cute Witch of the North: 6**
  10 L Zapp Brannigan: 6**
   1 M Zapp Brannigan: 7**
```

Here is an example of two singles, a single-fused, ready to be quad-fused with watts (for a total of 9 quads):
```
    2 L Anti-Seizure Meds: 1
    1 L Anti-Seizure Meds: 1*
    8 L Anti-Seizure Meds: 6**
```


*Combos/ComboMastery:*

First column is Combo Mastery level, 0-3. Second column is the combo name.  Third column is the number of item mastery stones available for that particular combo, blank for none. It takes 5 for CM1, 25 more for CM2, and 100 more for CM3.  Thus an available but unresearched CM3 would list 
`0 | name | 130`.  

The `Mastery Stone` line lists your Mastery Stones, the currency used to purchase stones from the Shop's Mastery tab.

e.g. this shows a cm3, a cm2 with enough stones for cm3, a cm2 with no extra stones, a cm1 with stones that wouldn't
add up to enough to be able to upgrade to cm2, and a cm0 with enough stones for cm3, and the total mastery stones.


```
3 | Beer Snot
2 | Alley Entertainment | 100
2 | Beer Jeff
1 | Artsy Tina | 5
0 | Hot Cocoa Louise | 130
245950 | Mastery Stone
```


## Individual Scripts Docs

### Adventure fights

These 
- adventure-iterate.sh
- adventure-buy-refills.sh
- adventure-fight5.sh

automate buying refills for Adventure, and, run fights in groups of 5. The script
`adventure-iterate.sh` combines the refill buying and fighting, that's the one you probably want.
For each iteration, it buys 30 *Energy Refill +10* packs, and then runs either 33 or 34 battles (however much it can).
If you are not over your card cap, you can have it buy
50k packs with coins as it iterates by uncommenting the ./buy-50kcoin-pack.sh clause.


### Arena fights

These 
- arena-iterate.sh
- arena-buy-refills.sh
- arena-fight5.sh

automate buying refills for Arena, and, run fights in groups of 5. The script 
`arena-iterate.sh` combines the refill buying and fighting, that's the one you probably want.
For each iteration, it buys 15 *Arena Refill +10* packs, and then runs 150 battles.
If you are not over your card cap, you can have it buy
50k packs with coins as it iterates by uncommenting the ./buy-50kcoin-pack.sh clause.


### Purchases

These 
- buy-1k-epic-stones.sh
- buy-50kcoin-pack.sh
- buy-golden-turd.sh
- buy-watts-converter.sh

automate buying the items indicated.

For example, here we see three turd purchases, gaining an epic, a legendary, and an epic:
```
$ ./buy-golden-turd.sh 3
"20029"
got 20029: 20029 3 Samurai Toshi
"30115"
got 30115: 30115 4 Orange Belt Arnold
"120106"
got 120106: 120106 3 Karate Francine
```

The numbers are the "levels" as defined by the game: 1 is Common, 2 Rare, 3 Epic, 4 Legendary, and 5 Mythic.


### Deck management

This 
- cardAndCmGrep.sh

is a convenience script that searches only your deck and CM, ignores the xml and other garbage that would come up
grep'ing the whole dir:


For example:
```
$ ./cardAndCmGrep.sh Meg.F
2 | Meg Football Kickoff | 15
   6 L Meg Football Kickoff: 6**
```

This 
- count-stones-and-gems.sh

tells you how many gems or mastery stones it takes to pay for a certain number of buys:


For example:
```
$ ./count-stones-and-gems.sh 10
10 buys:
gems: 16250
stones: 32500
```

These 
-  get-cards
-  get-deck
-  gen-cards
-  gen-cm
-  gen-cm-tokens 
-  gen-cm-combined 

can be ignored.  They are run from the Makefile.  Don't bother running them separately:

