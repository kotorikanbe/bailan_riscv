inpath=input('please input the input file path\n')
outpath=input('please input the output file path\n')
infile=open(inpath,"r")
outfile=open(outpath,"w")
outfile.write('memory_initialization_radix=16;\n')
outfile.write('memory_initialization_vector=\n')
instr=infile.readline()
while(1):
    outfile.write(instr.strip())
    instr=infile.readline()
    if(instr==''):
        outfile.write(';')
        break
    else:
        outfile.write(',\n')