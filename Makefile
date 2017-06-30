.PHONY: cards clean
cards:
	./get-cards
	./get-deck
	./gen-cards

clean:
	rm	card-id-name.tmp.xml card-id-name.xml cards-w-id out out.js units-w-levels-and-rarity

