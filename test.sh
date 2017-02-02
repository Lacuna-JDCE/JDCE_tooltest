# edit these
html_file_name="index.html"
main_js_file="js/app.js"



new_html_file_name="new_"$html_file_name
html_file="default/$html_file_name"
script_tags=$(grep -Eoi '<script [^>]+></script>' "$html_file")
scripts=$(echo "$script_tags" | grep -Eo 'src="[^\"]+"' | grep -oP 'src="\K[^"]+');

folders=(
	"closurecompiler_simple"
	"closurecompiler_advanced"
	"rollup"
	"webpack"
)

commands=(
	"closure-compiler --js $scripts --compilation_level SIMPLE_OPTIMIZATIONS --warning_level=QUIET --js_output_file compiled.js"
	"closure-compiler --js $scripts --compilation_level ADVANCED_OPTIMIZATIONS --warning_level=QUIET --js_output_file compiled.js"
	"rollup --format es $main_js_file --output compiled.js"
	"webpack $main_js_file compiled.js"
)


if [[ $@ == **clean** ]]
then
	echo -n "Cleaning up folder... "

	for i in "${!folders[@]}"
	do
		rm -r ./${folders[i]} 2> /dev/null
	done

	echo "done"

	exit
fi



echo -e "Running ${#folders[@]} tests with main HTML file '$html_file_name' and JS file '$main_js_file'\n"


for i in "${!folders[@]}"
do
	rm -r ./${folders[i]} 2> /dev/null
	echo -n "Running "${folders[$i]}"... "
	cp -r default ${folders[$i]}
	cd ${folders[$i]}
	`${commands[$i]}` 2> /dev/null
	cp $html_file_name $new_html_file_name
	sed -r -i -e 's|<script src="([^\"]*)"></script>||g' $new_html_file_name # remove all script src tags
	sed -r -i -e '/<\/body>/i <script src="compiled.js"><\/script>' $new_html_file_name # insert new script tag before </body>
	cd ../
	echo "done"
done
