.PHONY: all cards deck gen_cards cm clean

all: cards deck gen_cards cm

cards:
	./get-cards

deck:
	@date
	./get-deck

gen_cards:
	@date
	./gen-cards | sort | uniq -c > Decks/CARDS
	@date

cm: cards deck
	./gen-cm | sort -r > Combos/ComboMastery
	./gen-cm-tokens | sort -rn > Combos/ComboMasteryTokens

clean:
	@#rm	cards-w-id out units-w-levels-and-rarity
	rm	-f cards-w-id-and-rarity user.json units-w-levels ids-with-cm
