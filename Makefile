.PHONY: all cards deck gen_cards gen_cm cm clean

all: cards deck gen_cards gen_cm

cards:
	./get-cards

deck:
	./get-deck

gen_cards:
	time ./gen-cards | sort | uniq -c > Decks/CARDS

gen_cm:
	./gen-cm | sort -r > Combos/ComboMasteryLevels
	./gen-cm-tokens | sort -rn > Combos/ComboMasteryTokens
	./gen-cm-combined > Combos/ComboMastery

cm: cards deck gen_cm

clean:
	@#rm	cards-w-id out units-w-levels-and-rarity
	rm	-f cards-w-id-and-rarity user.json units-w-levels ids-with-cm
