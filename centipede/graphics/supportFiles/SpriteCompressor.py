def main():
    with open("MotionObject.txt", "r") as a:
        with open("MotionObject.hex", "w") as b:
            for line in a:
                color = line[0:-3]
                if(color == "000000"):
                    #black
                    b.write("00\n")
                elif(color == "FFFFC1"):
                    #cream
                    b.write("03\n")
                elif(color == "FF0000"):
                    #red
                    b.write("01\n")
                elif(color == "00FF00"):
                    #green
                    b.write("02\n")
                else:
                    print "Bad Color, %s" % color
    with open("StaticObject.txt", "r") as a:
        with open("StaticObject.hex", "w") as b:
            for line in a:
                color = line[0:-1]
                if(color == "000000"):
                    #black
                    b.write("00\n")
                elif(color == "FFFFC1"):
                    #cream
                    b.write("03\n")
                elif(color == "FF0000"):
                    #red
                    b.write("01\n")
                elif(color == "00FF00"):
                    #green
                    b.write("02\n")
                else:
                    print "Bad Color, %s" % color
    return
 
main()
