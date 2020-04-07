.PHONY: cards all deck clean

all: cards deck cm

cards:
	./get-cards

deck:
	@date
	./get-deck
	@date
	./gen-cards | sort | uniq -c > Decks/CARDS
	@date

cm:
	./gen-cm | sort -r > Combos/ComboMastery
	./gen-cm-tokens | sort -rn > Combos/ComboMasteryTokens

clean:
	@#rm	cards-w-id out units-w-levels-and-rarity
	rm	-f cards-w-id-and-rarity user.json units-w-levels ids-with-cm
