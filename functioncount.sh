folder=$1
total_occurences=0

for script in ${@:2}
do
	file="$folder$script"

	file_count="$(grep -o "function" $file | wc -l)"

	total_occurences=$(($total_occurences + $file_count))
done

echo $total_occurences
