

echo "--- Deleting old templates ---"

rm -rf ~/Library/Developer/Xcode/Templates/CollorCell.xctemplate
rm -rf ~/Library/Developer/Xcode/Templates/CollorController.xctemplate


echo "--- Installing new templates ---"

cp -r ./CollorCell.xctemplate 			~/Library/Developer/Xcode/Templates
cp -r ./CollorController.xctemplate 	~/Library/Developer/Xcode/Templates

echo "--- Success ---"