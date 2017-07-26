

echo "--- Deleting old templates ---"

rm -rf ~/Library/Developer/Xcode/Templates/CollorCell.xctemplate

echo "--- Installing new templates ---"

cp -r ./CollorCell.xctemplate ~/Library/Developer/Xcode/Templates

echo "--- Success ---"