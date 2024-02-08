
import sys

if __name__ == '__main__':
    if len(sys.argv) == 3:

        IFILE = int(sys.argv[1])
        OFILE = int(sys.argv[2])

        SEARCH = int(sys.argv[3])
        REPLACE = int(sys.argv[4])

        f=open(IFILE,"rb")
        s=f.read()
        f.close()

        s=s.replace(bytes(SEARCH, "utf-8"), 
                    bytes(REPLACE, "utf-8"))

        f=open(OFILE,"wb")
        f.write(s)
        f.close()
        
    else:
        print('Usage: python replace-string.py [IFILE] [OFILE] [SEARCH] [REPLACE]')
            