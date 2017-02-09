# Entry points.
# folder is the directory of the app, main_hmtl_file is used to extract all the <script> tags, main_js_file for tools that require a script entry point.
main_folder="default/"
main_html_file="index.html"
main_js_file="js/app.js"

# That's it! Beware, below be dragons :)




# Check if required files are there.
if [ ! -d "$main_folder" ]; then
	echo -e "\033[0;31mCouldn't find main folder '$main_folder'\033[0;37m"
	exit
fi

if [ ! -f "$main_folder$main_html_file" ]; then
	echo -e "\033[0;31mCouldn't find main HTML file '$main_html_file'\033[0;37m"
	exit
fi

if [ ! -f "$main_folder$main_js_file" ]; then
	echo -e "\033[0;31mCouldn't find main JS file '$main_js_file'\033[0;37m"
	exit
fi


# Generate file names
new_html_file="new_"$main_html_file
html_file="$main_folder$main_html_file"
compiled_js_file="compiled.js"

# Extract all script tag src's.
script_tags=$(grep -Eoi '<script [^>]+></script>' "$html_file")
scripts=$(echo "$script_tags" | grep -Eo 'src="[^\"]+"' | grep -oP 'src="\K[^"]+');


# These are the names of the applications we're going to test.
# The script creates a directory with this name to put the new files in.
folders=(
	"closurecompiler_simple"
	"closurecompiler_advanced"
	"rollup"
	"webpack"
)

# The actual commands to run (1:1 with the folders array, above)
commands=(
	"closure-compiler --js $scripts --compilation_level SIMPLE_OPTIMIZATIONS --warning_level=QUIET --js_output_file $compiled_js_file"
	"closure-compiler --js $scripts --compilation_level ADVANCED_OPTIMIZATIONS --warning_level=QUIET --js_output_file $compiled_js_file"
	"rollup --format es $main_js_file --output $compiled_js_file"
	"webpack $main_js_file $compiled_js_file"
)


# If the 'clean' argument is set, remove all folders we might have created.
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


# First, retrieve the amount of 'function' keywords in each script file.
function_keyword_count=$(./functioncount.sh $main_folder $scripts)
script_tokens=($scripts)
script_count=${#script_tokens[@]}

# Output run info.
echo -e "Running \e[1m${#folders[@]}\e[0m tests with the following settings:\n"
printf "\t%-25s %s\n" "folder" $main_folder
printf "\t%-25s %s\n" "HTML file" $main_html_file
printf "\t%-25s %s\n" "JS file" $main_js_file
printf "\t%-25s %s\n" "# JS files extracted" $script_count
echo -e "\t# \e[3mfunction\e[0m keywords       $function_keyword_count"
echo -e "\n"

# Output table headers.
printf "\e[1m%-30s %-15s %-15s %s\n\e[0m" "Tool" "# function" "% original" "JS errors?"
printf "=%.0s" {1..79}
echo -e -n "\n"


# Loop over each entry to test:
for i in "${!folders[@]}"
do
	# Remove the folder in case it already exists, then copy the default folder, then move into the folder.
	rm -r ./${folders[i]} 2> /dev/null
	cp -r default ${folders[$i]}
	cd ${folders[$i]}

	# Run te tool!
	`${commands[$i]}` 2> /dev/null

	# Create a new HTML file, remove all <script> tags, append the compiled JS script before the </body>.
	cp $main_html_file $new_html_file
	sed -r -i -e 's|<script src="([^\"]*)"></script>||g' $new_html_file
	sed -r -i -e '/<\/body>/i <script src="'$compiled_js_file'"><\/script>' $new_html_file

	# Move back up a directory, and count the occurences of the function keyword in the compiled JS script.
	cd ../
	function_count=$(./functioncount.sh "${folders[i]}/" $compiled_js_file)
	percent=$(echo "scale=1; $function_count*100/$function_keyword_count" | bc)

	# Run a headless Chromium instance and retrieve the number of errors.
	javascript_errors=$(node jserrorcount.js "${folders[i]}/$new_html_file")

	# Output tool name and occurences.
	printf "%-30s %-15s %-15s %s" ${folders[$i]} $function_count "$percent%"

	if [ $javascript_errors -gt 0 ] ; then
		echo -e "\033[0;31myes \033[0;37m($javascript_errors)"
	else
		echo -e "\033[0;32mno\033[0;37m"
	fi

done
