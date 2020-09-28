.PHONY: all cards deck gen_cards gen_cm cm clean

all: cards deck gen_cards gen_cm

cards:
	time ./get-cards

deck:
	time ./get-deck

gen_cards:
	time ./gen-cards | sort | uniq -c > Decks/CARDS

gen_cm:
	time ./gen-cm | sort -r > Combos/ComboMasteryLevels
	time ./gen-cm-tokens | sort -rn > Combos/ComboMasteryTokens
	time ./gen-cm-combined > Combos/ComboMastery

cm: cards deck gen_cm

clean:
	rm	-f cards-w-id-and-rarity user.json units-w-levels ids-with-cm vars
