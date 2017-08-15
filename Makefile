.PHONY: cards all deck clean

all: cards deck

cards:
	./get-cards
	./get-deck

deck:
	./gen-cards | sort | uniq -c

clean:
	rm	cards-w-id out units-w-levels-and-rarity

