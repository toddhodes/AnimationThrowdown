.PHONY: cards clean
cards:
	./get-cards
	./get-deck
	./gen-cards

clean:
	rm	cards-w-id out out.js units-w-levels-and-rarity

