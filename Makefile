# Encrypt the report with the fixed page password from .env and publish to GitHub Pages.
encrypt:
	@set -a; . ./.env; set +a; npx --yes staticrypt public-encrypted/index.html -p "$$PAGE_PASSWORD" -d public --short --remember 14 --config .staticrypt.json --template scripts/encrypt/template.html && echo "encrypted -> public/index.html"

verify:
	@set -a; . ./.env; set +a; rm -rf decrypted && npx --yes staticrypt --decrypt public/index.html -p "$$PAGE_PASSWORD" --config .staticrypt.json && diff -q public-encrypted/index.html decrypted/index.html && echo "decrypt OK - matches source" ; rm -rf decrypted

refresh:
	python3 ../report/build_report.py && cp ../report/index.html public-encrypted/index.html && $(MAKE) encrypt

publish: encrypt
	git add public && git commit -m "Update report" && git push
