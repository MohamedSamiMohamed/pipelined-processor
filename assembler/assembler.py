import re
dict = {}
with open("dectionary.txt") as dictFile:
    for line in dictFile:
        (key,val)=line.split()
        if(key[0]!='/'):
            dict[str(key)]=val
print(dict)


def expandInstruction(instruction):
    instructions=[]
    op=instruction.split(" ")[1]
    if(instruction.find("CALL")!=-1):
        instructions.append(instruction)
        instructions.append("DECSP")
        instructions.append(" ".join(["JMP",op]))

    elif(instruction.find("PUSH")!=-1):
        instructions.append(instruction)
        instructions.append("DECSP") 
    return instructions

def decodeInstruction(instruction):
    code=[""]
    instItems=instruction.split(" ")
    print(instItems)
    #no operand instructions
    if(len(instItems)==1):
        code[0]+=dict[instItems[0]]
        code[0]+="00000000000"
    else:
        code[0]+=dict[instItems[0]]
        operands=instItems[1]
        if(operands.find(",")!=-1):
            op1,op2=operands.split(",")
            # code[0]+=dict[op1]
            if(op2.isdecimal()):
                val = int(op2,16)
                imm = "{0:16b}".format(val).replace(" ","0")
                code.append(str(imm))
                op2=op1
            elif(op2.find("(")!=-1):
                op2Offset=op2.split("(")[0]
                op2Reg = (op2.split("(")[1]).split(")")[0]
                val = int(op2Offset,16)
                offset = "{0:16b}".format(val).replace(" ","0")
                code.append(str(offset))
                op2=op1
                op1=op2Reg

            code[0]+=dict[op1]
            code[0]+=dict[op2]
            code[0]+="00000"

        else:
            code[0]+=dict[operands]
            code[0]+=dict[operands]
            code[0]+="00000"

    return code

instructions=[]
with open("our test case .txt") as codeFile:
    for line in codeFile:
        line = line.upper()
        line = line.replace('\t', '')
        line = line.strip()
        if(len(line)!=0):
            if(line[0]!='#' and line[0]!='\n'):
                line=re.split('#',line)[0]
                line=line.rstrip()
                if(line.find("CALL")!=-1 or line.find("PUSH")!=-1):
                    expandedInstruction=expandInstruction(line)
                    for inst in expandedInstruction:
                        instructions.append(inst)
                else:               
                    instructions.append(line)

print(instructions)
memlocation=0
decodedInstruction=["0000000000000000"]*50
for instruction in instructions:
    if(instruction.find(".ORG")!=-1):
        print("i'm org")
        memlocation=int(re.split(' ',instruction)[1])
    elif(instruction.isdecimal()):
        val = int(instruction,16)
        address = "{0:16b}".format(val).replace(" ","0")
        decodedInstruction[memlocation]=address
        memlocation+=1
    else:
        codes=decodeInstruction(instruction)
        print(codes)
        for code in codes: 
            decodedInstruction[memlocation]=code
            memlocation+=1


fOut = open("assemblerOutput.txt","w")
fOut.write("\n".join(decodedInstruction))
memory="// memory data file (do not edit the following line - required for mem load use) \n// instance=/fetchstage/Mem/RamArray \n// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1\n"
for instruction in instructions:
    memory+=str(memlocation)+": "


outputFile = open("inst-memory.mem","w")
outputFile.writelines(memory)
