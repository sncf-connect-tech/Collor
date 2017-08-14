

echo "--- Deleting old templates ---"

rm -rf ~/Library/Developer/Xcode/Templates/Collor/CollorCell.xctemplate
rm -rf ~/Library/Developer/Xcode/Templates/Collor/CollorController.xctemplate
rm -rf ~/Library/Developer/Xcode/Templates/Collor/CollorSection.xctemplate


echo "--- Installing new templates ---"

mkdir -p ~/Library/Developer/Xcode/Templates/Collor
cp -r ./CollorCell.xctemplate 			~/Library/Developer/Xcode/Templates/Collor
cp -r ./CollorController.xctemplate 	~/Library/Developer/Xcode/Templates/Collor
cp -r ./CollorSection.xctemplate 		~/Library/Developer/Xcode/Templates/Collor

echo "--- Success ---"