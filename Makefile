p:
	cabal build
	at /media/banacorn/8258dc47-a771-439e-9a7c-04c04ddf9ccf/d/all.txt | time ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -sstderr -RTS

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

a:
	cabal build
	cat data/data | time ./dist/build/pre-homework/pre-homework +RTS -K2000m -H500m -RTS
	# less output
b:
	cabal build
	cat /media/banacorn/8258dc47-a771-439e-9a7c-04c04ddf9ccf/d/all.txt | time ./dist/build/pre-homework/pre-homework +RTS -K2000m -H500m -RTS