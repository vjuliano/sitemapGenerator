#!/bin/bash


#Copyright (c) 2024 Vincent Juliano
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.



sitemap=""
basepath=""
domain=""
basepath_length=""

function buildMap() {
	dir="$1"

	for file in "$dir"/*; do
		relative="$domain${file:basepath_length}"
		
		if [ -f "$file" ]; then
			echo '<url>' >> "$sitemap"
			echo "<loc>$relative</loc>" >> "$sitemap"
			echo '</url>' >> "$sitemap"
		fi

		if [ -d "$file" ]; then
			buildMap "$file"
		fi

	done
}


function writeOpeningTags() {
	tags='<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

	echo "$tags" > "$sitemap"
}

function writeClosingTags() {
	echo '</urlset>' >> "$sitemap"
}

function getParams() {
	read -p "Enter site root directory [/var/www]: " basepath
	basepath=${basepath:-/var/www}
	readonly basepath

	read -p "Enter path for generated xml file [~/sitemap.xml]: " sitemap
	sitemap=${sitemap:-~/sitemap.xml}
	readonly sitemap

	read -p "Enter domain of site being mapped: [https://example.com] " domain
	domain=${domain:-https://example.com}
	readonly domain

	basepath_length=${#basepath}
	readonly basepath_length
}

getParams

writeOpeningTags

buildMap "$basepath"

writeClosingTags
