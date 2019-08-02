#!/bin/sh
PRETEXT=/mnt/data/Dropbox/Script/TeX/pretext
BASENAME=`basename $1`
set -eu

xsltproc \
	-o references.xml.ptx \
	bibtexml2ptx.xsl \
	references.bibtexml

xsltproc \
	--xinclude \
	-o $BASENAME.ptx \
	$PRETEXT/xsl/mathbook-preprocess.xsl \
	$BASENAME
INPUTXML=$BASENAME.ptx

for format in html epub latex; do
	echo "Output format: $format"
	mkdir -p $format
	cp -a image $format/
	cd $format
	xsltproc \
		--xinclude \
		--stringparam numbering.theorems.level '1' \
		--stringparam latex.geometry 'a4paper,total={195mm,270mm},centering' \
		--stringparam html.css.extra 'image/style.css' \
		-o $BASENAME.$format \
		$PRETEXT/xsl/mathbook-$format.xsl \
		../$INPUTXML
	if [ $format = latex ] ; then
		lualatex $BASENAME.$format
	fi
	# if [ $format = epub ] ; then
	# fi
	cd ..
done
