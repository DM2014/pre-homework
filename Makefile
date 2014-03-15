p:
	cabal build
	cat data/loc.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -p -RTS

h:
	cabal build
	cat data/loc.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -p -h -RTS

	hp2ps -c pre-homework.hp
	open pre-homework.ps 

t:
	profiteur pre-homework.prof
	open pre-homework.prof.html 