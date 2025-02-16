version = $(shell poetry version -s)

python_sources = $(wildcard streamlit_cookies_manager_ext/*.py) pyproject.toml MANIFEST.in
js_sources := $(wildcard streamlit_cookies_manager_ext/public/*) $(wildcard streamlit_cookies_manager_ext/src/*) streamlit_cookies_manager_ext/tsconfig.json
js_npm_install_marker = streamlit_cookies_manager_ext/node_modules/.package-lock.json

build: streamlit_cookies_manager_ext/build/index.html sdist wheels

sdist: dist/streamlit-cookies-manager-ext-$(version).tar.gz
wheels: dist/streamlit_cookies_manager_ext-$(version)-py3-none-any.whl

js: streamlit_cookies_manager_ext/build/index.html

dist/streamlit-cookies-manager-ext-$(version).tar.gz: $(python_sources) js
	poetry build -f sdist

dist/streamlit_cookies_manager_ext-$(version)-py3-none-any.whl: $(python_sources) js
	poetry build -f wheel

streamlit_cookies_manager_ext/build/index.html: $(js_sources) $(js_npm_install_marker)
	cd streamlit_cookies_manager_ext && npm run build

$(js_npm_install_marker): streamlit_cookies_manager_ext/package.json streamlit_cookies_manager_ext/package-lock.json
	cd streamlit_cookies_manager_ext && npm install

clean:
	-rm -r -f dist/* streamlit_cookies_manager_ext/build/*
