def main():
    with open("pfram.txt", "r") as a:
        with open("pfram.hex", "w") as b:
            #for x in xrange(960):
            for line in a:
                bytes = line[7:]
                bytes = bytes.replace(" ", "\n")
                #bytes = "1F\n"
                b.write(bytes)
    
    return

main()
