import re
import struct
import sys
target=sys.argv[-1]
while(1):
    try:
        binaryfile=open(target,"rb")
    except:
        print('An wrong occurred,try again')
        target=input("please input the binary file's path:")
    else:
        print('successfully read this file!')
        break
outputname=(re.search(r'([^/]*)\.bin$',target)).group(1)
outputname=outputname+'.mem'
outputfile=open(outputname,'w')
bin_str=binaryfile.read(4)
while(1):
    try:
      tmp_tup=struct.unpack('1I',bin_str)
    except:
      break
    outputfile.write('%08x\n'%(tmp_tup[0]))
    bin_str=binaryfile.read(4)
binaryfile.close()
outputfile.close()