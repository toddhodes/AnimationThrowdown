# AnimationThrowdown
Animation Throwdown scripts


These scripts get your deck card inventory, and Combo Mastery, and output it as text. 

## Setup

### User info

To do API calls to kongregate, you need your player ID and password hash.  You can get these 
by turning on the "Developer Console" in your web browser, and investigating some of the traffic
while playing the game. This is the *same info* you use to register with Zbot; the user ID is your 
player ID, visible in your player detail card.  Asking about this in Line as if you're using ZBot is 
the easiest way to get help on this.

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

In the directory where you cloned this, simply run 
```
make
```


## Sample output

Here's some sample output; you can see my complete card set and combo masteries here:

https://raw.githubusercontent.com/toddhodes/AnimationThrowdown/master/Decks/CARDS

https://raw.githubusercontent.com/toddhodes/AnimationThrowdown/master/Combos/ComboMastery

* Decks/CARDS:

```
   1 E Free Weed Hayley: 5**
   6 L Wozniak Nerd Academy: 6**
   1 L Yacht Dreams: 6**
   6 L Zapp Brannigan Portrait: 6**
  10 L Zapp Brannigan: 6**
   1 L Zapp Figurines: 1
   1 L Zapp Figurines: 2*
   2 L Zapp Figurines: 6**
   1 M Amy: 6*
   1 M Anti-Seizure Meds: 7*
   1 M Bender: 1**
   1 M Wagstaff Whaler: 6
   1 M Walking Man Exhibit: 6
   1 M Wong Casino: 4
   1 M Zapp Brannigan: 2**
```


* Combos/comboMastery:

```
3 | Zombie Jimmy Jr.
3 | Wingnut Leela
3 | Wingnut Amy
3 | Whiskey Bartender
3 | Whale Hunter Amy
3 | War Horse
2 | Summer Guy | 70
2 | Stressed Out Leela | 30
2 | Stickin' Hank
2 | Stan vs Mafia | 55
2 | Squirrel Death | 100
2 | Spray on Army Fry
2 | Spray Painter | 70
2 | Space Steve | 75
2 | Space Stan | 15
2 | Space Cadet Chris | 25
2 | Softball Lois | 100
2 | Softball Bill
2 | Slow Dance Jimmy Jr. | 10
1 | Kawaii Klaus | 120
1 | K Pop Peter | 5
1 | Joystick Steve | 110
1 | Jellybean Phone Klaus | 5
1 | Hot Cocoa Gene | 25
1 | Honeybucket Student | 125
1 | Honey Mustache Stewie | 5
1 | Appetizer Addict Brian | 10
1 | Anally Defaced | 75
1 | Amy's Talking Tattoo | 125
1 | Alcohol Bath | 95
1 | ABC Quagmire | 45
 Mastery Stone | 435200
 Zac Sawyer | 130
 Screen Repairer | 130
 Rich Bobby | 130
 Nun Francine | 130
 Maxi Paddy | 130
 Prom Luanne | 5
 Ecstacy Francine | 5
 Corporate Training | 5
```


