all:
	love ./

dev:
	love ./ --hotreload

images:
	aseprite -b assets/exit.aseprite --save-as assets/exit.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2025-winter-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2025-winter-game-jam/"
	python3 -m http.server
