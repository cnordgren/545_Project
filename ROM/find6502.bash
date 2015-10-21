file="~/Private/18545/545_Project/ROM/"

for i in $( ls ~/Private/18545/545_Project/ROM ); do
    ~/Downloads/dcc6502-master/dcc6502 -o 0x0000 -d $i > ./output$i.txt
done
