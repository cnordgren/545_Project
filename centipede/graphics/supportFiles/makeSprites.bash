
hexdump -v -e ' 3/1 "%02X" "\n"' staticRotated.raw > StaticObject.txt
hexdump -v -e ' 4/1 "%02X" "\n"' motionRotated.raw > MotionObject.txt
python ./SpriteCompressor.py

mv StaticObject.hex ../
mv MotionObject.hex ../
