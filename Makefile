.PHONY: all cards deck gen_cards gen_cm cm clean
export TIMEFORMAT=.	%Rs real	%Us user	 %Ss sys


all: cards deck gen_cards gen_cm

cards:
	time ./get-cards

deck:
	time ./get-deck

gen_cards:
	time ./gen-cards | sort | uniq -c > Decks/CARDS

gen_cm:
	time ./gen-cm > Combos/ComboMasteryLevels
	./gen-cm-tokens | sort -rn > Combos/ComboMasteryTokens
	./gen-cm-combined > Combos/ComboMastery

cm: cards deck gen_cm

clean:
	rm	-f cards-w-id-and-rarity /tmp/user.json units-w-levels ids-with-cm vars o-*
