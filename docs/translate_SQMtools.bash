SQMTOOLS_DOCS_IN=~/.local/opt/SqueezeMeta/lib/SQMtools/man
SQMTOOLS_DOCS_OUT=source/SQMtools
for file in "$SQMTOOLS_DOCS_IN/"*Rd; do
	name=$(basename "$file" .Rd)
	Rscript -e "tools::Rd2HTML(\"$file\")" | pandoc -f html -o $SQMTOOLS_DOCS_OUT/$name.rst
	#pandoc -s lib/SQMtools/man/loadSQM.html -o loadSQM.rst
done
