all:
	love ./

dev:
	love ./ --hotreload

images:
	aseprite -b assets/trophy.aseprite --save-as assets/trophy.png
	aseprite -b assets/drill-action.aseprite --save-as assets/drill-action.png
	aseprite -b assets/wait-action.aseprite --save-as assets/wait-action.png
	aseprite -b assets/jump-action.aseprite --save-as assets/jump-action.png
	aseprite -b assets/long-jump-action.aseprite --save-as assets/long-jump-action.png
	aseprite -b assets/spurs.aseprite --save-as assets/spurs.png
	aseprite -b assets/liverpool.aseprite --save-as assets/liverpool.png
	aseprite -b assets/arsenal.aseprite --save-as assets/arsenal.png
	aseprite -b assets/wolves.aseprite --save-as assets/wolves.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2025-winter-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2025-winter-game-jam/"
	python3 -m http.server
