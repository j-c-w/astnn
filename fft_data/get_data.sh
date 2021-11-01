#!/bin/bash

set -eu
# Get the FFT code used by each project.
if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <folder from DSPAcceleratorSupport>"
	exit 1
fi

code_folder=$1

copy_files() {
	local listname=$1

	while read line; do
		echo $line
		name=$(echo $line | cut -d: -f 1)
		foldname=$code_folder/$name/self_contained_code.c
		if [[ -f $foldname ]]; then
			cp $foldname $name.c
			if [[ -f $code_folder/$name/self_contained_code.h ]]; then
				cp $code_folder/$name/self_contained_code.h .
			fi

			gcc -E $name.c > tmp || (echo "failed on $name"; continue)
			sed -i "/# /g" tmp
			sed -i "/__attribute__/g" tmp
			sed -i "/__extension__/g" tmp
			mv tmp $name.c
			rm -f self_contained_code.h 
		fi

		# if [[ $name == "xiahouzouxin_fft" ]]; then
		# 	# tail -n 64 $name.c > tmp
		# 	# mv tmp $name.c
		# 	echo ""
		# elif [[ $name == "JodiTheTigger_meow_fft" ]]; then
		# 	# tail -n 67 $name.c > tmp
		# 	# mv tmp $name.c
		# 	echo ""
		# elif [[ $name == "akw0088_fft" ]]; then
		# 	# tail -n 62 $name.c > tmp
		# 	# mv tmp $name.c
		# 	echo ""
		# else
		# 	echo "Due to unknown line count, skipping $line"
		# 	rm $name.c
		# fi
	done <$listname
}

copy_files $code_folder/FINAL_LIST
copy_files $code_folder/BROKEN

# Clear empties
find -size 0 | xargs rm -f

# Temporarily remove the ones with the __gnu_list shit
rg __gnuc_va_list -c | cut -f1 -d: | xargs rm
