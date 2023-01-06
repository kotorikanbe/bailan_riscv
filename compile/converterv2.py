import re
import sys
target=sys.argv[-1]
while(1):
    try:
        binaryfile=open(target,"r")
    except:
        print('An wrong occurred,try again')
        target=input("please input the binary file's path:")
    else:
        print('successfully read this file!')
        break
outputname=(re.search(r'([^/]*)\.ver$',target)).group(1)
outputname=outputname+'v2'+'.mem'
outputfile=open(outputname,'w')
bin_str=binaryfile.read(3)
count=0
str_list=[]
while(1):
    bin_str=bin_str.strip()
    if(bin_str==''):
        break
    if(bin_str[0]=='@'):
        binaryfile.readline()
        bin_str=binaryfile.read(3)
        continue
    if(count<3):
        str_list.append(bin_str)
        count+=1
    else:
        str_list.append(bin_str)
        count=0
        str_list.reverse()
        outputfile.write(''.join(str_list)+'\n')
        str_list=[]
    bin_str=binaryfile.read(3)