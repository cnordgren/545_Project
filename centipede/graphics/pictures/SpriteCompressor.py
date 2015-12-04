def main():
    with open("StaticObject.txt", "r") as a:
        with open("SpriteBin.hex", "wb") as b:
            for line in a:
                color = line[0:-1]
                if(color == "000000"):
                    b.write(b'\x00')
                elif(color == "FFFFC1"):
                    b.write(b'\x03')
                elif(color == "FF0000"):
                    b.write(b'\x01')
                elif(color == "00FF00"):
                    b.write(b'\x02')
                else:
                    print "Bad Color, %s" % color
    return
                
main()
