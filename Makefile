.PHONY: cards all deck clean

all: cards deck

cards:
	./get-cards

deck:
	./get-deck
	./gen-cards | sort | uniq -c > Decks/CARDS

clean:
	@#rm	cards-w-id out units-w-levels-and-rarity
	rm	cards-w-id-and-rarity out units-w-levels

