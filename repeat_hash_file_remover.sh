#!/bin/bash
reference_path=$1
reference_real_path=$(realpath --relative-base = "$reference_path")

folder_occurrence=$(ls -F "$reference_real_path" | grep "/")
if [ -n "$folder_occurrence" ]; then
    echo "$folder_occurrence" > /tmp/folders.txt
    while read folder; do
        cd "$reference_real_path/$folder"
        file_occurrence=$(md5sum *)
        if [ -n "$file_occurrence" ]; then
            echo "$file_occurrence" > /tmp/files.txt
            while read file; do 
                hash=$(echo $file | cut -d" " -f1)
                hash_occurrence=$(md5sum * | grep "$hash" | wc -l) 
                if [ $hash_occurrence -gt 1 ]; then
                    name_file=$(echo $file | cut -d" " -f2)
                    rm "$name_file"
                    echo "*** $reference_path/$folder: \"$name_file\" file removed"
                fi
            done < /tmp/files.txt
        fi
    done < /tmp/folders.txt
else echo "*** No folders found"
fi
rm /tmp/files.txt /tmp/folders.txt 2>/dev/null
