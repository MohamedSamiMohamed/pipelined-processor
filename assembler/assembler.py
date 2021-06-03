import re
dict = {}
with open("dectionary.txt") as dictFile:
    for line in dictFile:
        (key,val)=line.split()
        if(key[0]!='/'):
            dict[str(key)]=val
# print(dict)
instructions=[]
with open("code.txt") as codeFile:
    for line in codeFile:
        line = line.upper()
        line = line.replace('\t', '')
        line = line.strip()
        if(len(line)!=0):
            if(line[0]!='#' and line[0]!='\n'):
                line=re.split('#',line)[0]                
                instructions.append(line)

# print(instructions)
memlocation=0
decodedInstruction=["0000000000000000"]*32
for instruction in instructions:
    if(instruction.find(".ORG")!=-1):
        print("i'm org")
        memlocation=re.split(' ',instruction)[1]
    elif(instruction.isdecimal()):
        val = int(instruction,16)
        address = "{0:16b}".format(val).replace(" ","0")
        decodedInstruction[memlocation]=address
        memlocation+=1
    # else:
    #     # decodedInstruction[memlocation]=



memory="// memory data file (do not edit the following line - required for mem load use) \n// instance=/fetchstage/Mem/RamArray \n// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1\n"
for instruction in instructions:
    memory+=str(memlocation)+": "


outputFile = open("inst-memory.mem","w")
outputFile.writelines(memory)
