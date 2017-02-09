# Usage: functioncount.sh folder script1 script2 script3 ...

# Save folder location and # occurrences.
folder=$1
total_occurrences=0

# For each script we passed:
for script in ${@:2}
do
	# Generate full path.
	file="$folder$script"

	# Get the # of occurrences.
	file_count="$(grep -o "function" $file | wc -l)"

	# Add to total # of occurrences.
	total_occurrences=$(($total_occurrences + $file_count))
done

# Output the # of occurrences.
echo $total_occurrences
