p:
	cabal build
	cat data/loc.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -p -RTS

h:
	cabal build
	cat data/loc.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -p -hy -RTS

	hp2ps -c pre-homework.hp
	open pre-homework.ps 

h0:
	cabal build
	cat data/loc0.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -p -hy -RTS

	hp2ps -c pre-homework.hp
	open pre-homework.ps 

t:
	profiteur pre-homework.prof
	open pre-homework.prof.html 