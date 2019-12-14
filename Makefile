.PHONY: cards all deck clean

all: cards deck cm

cards:
	./get-cards

deck:
	./get-deck
	./gen-cards | sort | uniq -c > Decks/CARDS

cm:
	./gen-cm | sort -r > Combos/ComboMastery

clean:
	@#rm	cards-w-id out units-w-levels-and-rarity
	rm	-f cards-w-id-and-rarity user.json units-w-levels ids-with-cm
