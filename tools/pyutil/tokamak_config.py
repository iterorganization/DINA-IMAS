


def ReadCoilData(self, f):
    output = {}      
    output["type"] = "coil"
    
    output["name"] = f.readline().strip()
    
    props = self.ReadRowStr(f)
    if len(props) != 4:
    print("Incorrect properties amount: " + str(len(props)))
    output["items_p"] = [QtWidgets.QTableWidgetItem(x) for x in props]
    
    geometry = self.ReadRowStr(f)
    if len(geometry) != 6:
    print("Incorrect geometry items amount: " + str(len(geometry)))     
    output["items_g"] = [QtWidgets.QTableWidgetItem(x) for x in geometry]
    return output



def ReadResistanceData(self, f, n):
    output = {}
    output["type"] = "resist-list"
    data = []
    
    for i in range(n):
    line = f.readline().rstrip()
    description = line.split()
    data.append(float(description[0]))
    
    output["items"] = [QtWidgets.QTableWidgetItem(str(x)) for x in data]
    return output



def ReadTokamakConfig(self, f):
    output = {}
    
    # Coils
    record = {}
    data = []
    f.readline()
    NPF = self.ReadRow(f)
    NPF_items = [QtWidgets.QTableWidgetItem(str(x)) for x in NPF]
    record["common_geom"] = NPF_items
    npf = NPF[0]
    print("npf = " + str(npf))
    for i in range(npf):
    data.append(self.ReadCoilData(f))
    record["geometry"] = data
    
    # Coil resistances
    data = []
    f.readline()
    NPF = self.ReadRow(f)
    record["common_res"] = NPF
    npf = NPF[0]
    print("npf res = " + str(npf))
    record["resist"] = self.ReadResistanceData(f, npf) 
    
    output["coils"] = record
    
    
    # Vessel
    record = {}
    data = []
    f.readline()
    NCAM = self.ReadRow(f)
    record["common_geom"] = NCAM
    ncam = NCAM[0]
    print("ncam = " + str(ncam))
    for i in range(ncam):
    data.append(self.ReadCoilData(f))
    record["geometry"] = data
    
    # Vessel resistances
    f.readline()
    NCAM = self.ReadRow(f)
    record["common_res"] = NCAM
    ncam = NCAM[0]
    print("ncam res = " + str(ncam))
    record["resist"] = self.ReadResistanceData(f, ncam)
    
    output["vessel"] = record
    
    
    # Loops
    record = {}
    f.readline()
    NLOOP = self.ReadRow(f)
    record["common"] = NLOOP
    nloop = NLOOP[0]
    print("nloop = " + str(nloop))
    loops = [] 
    #loopR = []
    #loopZ = []
    for i in range(nloop):
    line = self.ReadRow(f)
    #loopR.append(line[0])
    #loopZ.append(line[1])  
    loop = {}
    loop["r"] = QtWidgets.QTableWidgetItem(str(line[0]))
    loop["z"] = QtWidgets.QTableWidgetItem(str(line[1]))
    loops.append(loop)
    #record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in loopR] 
    #record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in loopZ] 
    record["items"] = loops
    output["loops"] = record
    
    
    # Probes
    record = {}
    f.readline()
    NPROB = self.ReadRow(f)
    NPROB_items = [QtWidgets.QTableWidgetItem(str(x)) for x in NPROB]
    record["common"] = NPROB_items
    nprob = NPROB[0]
    print("nprob = " + str(nprob))
    #probR = []
    #probZ = []
    #probA = []
    #probL = []
    probes = []
    for i in range(nprob):
    line = self.ReadRow(f)
    #probR.append(line[0])
    #probZ.append(line[1])    
    #probA.append(line[2])
    #probL.append(line[3])         
    probe = {}
    probe["r"] = QtWidgets.QTableWidgetItem(str(line[0]))
    probe["z"] = QtWidgets.QTableWidgetItem(str(line[1]))
    probe["a"] = QtWidgets.QTableWidgetItem(str(line[2]))
    probe["l"] = QtWidgets.QTableWidgetItem(str(line[3]))
    probes.append(probe)       
    #record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probR]
    #record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probZ]
    #record["items_a"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probA]
    #record["items_l"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probL]
    record["items"] = probes
    output["probes"] = record
    
    
    # Limiter
    record = {}
    f.readline()
    NLIM = self.ReadRow(f)
    record["common"] = NLIM
    nlim = NLIM[0]
    print("nlim = " + str(nlim))
    limR = []
    limZ = []
    for i in range(nlim):
    line = self.ReadRow(f)
    limR.append(line[0])
    limZ.append(line[1])         
    record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in limR] 
    record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in limZ] 
    output["limiter"] = record
    
    
    # Area
    record = {}
    record["name"] = f.readline().rstrip()
    lineR = self.ReadRow(f)
    lineZ = self.ReadRow(f)
    record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in lineR]
    record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in lineZ]
    output["area"] = record
    
    
    output["type"] = "tokamakdata"
    
    return output



def SaveTokamakConfig(self, f, record):
    
    # Coils
    recsave = record["coils"]
    f.write("COILS   number:   npf   !tokamak_config.dat  \n") # comment
    f.write(recsave["common_geom"][0].text() + "\n") # npf
    for coil in recsave["geometry"]:
    self.SaveFilePart(f, coil)
    f.write("res_PF:   npf  \n") # comment
    f.write(str(recsave["common_res"][0]) + "\n") # npf
    self.SaveFilePart(f, recsave["resist"])
    
    
    # Vessel
    recsave = record["vessel"]
    f.write("Vessel   number:   ncam  \n") # comment
    f.write(str(recsave["common_geom"][0]) + "\n") # ncam
    for coil in recsave["geometry"]:       
    self.SaveFilePart(f, coil)     
    f.write("res_ves:   ncam  \n") # comment
    f.write(str(recsave["common_res"][0]) + "\n") # ncam
    self.SaveFilePart(f, recsave["resist"])
    
    
    # Loops
    recsave = record["loops"]
    f.write("Loops   number:   kloop  \n") # comment
    f.write(str(recsave["common"][0]) + "\n") # nloop
    nloop = len(recsave["items"])
    for i in range(nloop):
    s1 = recsave["items"][i]["r"].text()
    s2 = recsave["items"][i]["z"].text()
    f.write("  " + s1 + "  " + s2 + "\n")
    
    
    # Probes
    recsave = record["probes"]
    f.write("Probes   number   and   division:   kprobe   kpb \n") # comment
    f.write(recsave["common"][0].text() + "  " + recsave["common"][1].text() + "\n") # nprobes, subdivisions
    #self.SaveFilePart(f, recsave["common"])
    nprobes = len(recsave["items"])
    for i in range(nprobes):
    s1 = recsave["items"][i]["r"].text()
    s2 = recsave["items"][i]["z"].text()
    s3 = recsave["items"][i]["a"].text()
    s4 = recsave["items"][i]["l"].text()
    f.write("  " + s1 + "  " + s2 + "  " + s3 + "  " + s4 + "\n")


    # Limiter
    recsave = record["limiter"]
    f.write("Limiter   number:   n_limiter  \n") # comment
    f.write(str(recsave["common"][0]) + "\n") # nlim
    nlim = len(recsave["items_r"])
    for i in range(nlim):
    s1 = recsave["items_r"][i].text()
    s2 = recsave["items_z"][i].text()
    f.write("  " + s1 + "  " + s2 + "\n")
    
    
    # Area
    recsave = record["area"]
    f.write(recsave["name"] + "\n")
    s1 = recsave["items_r"][0].text()
    s2 = recsave["items_r"][1].text()
    f.write("  " + s1 + "  " + s2 + "\n")
    s1 = recsave["items_z"][0].text()
    s2 = recsave["items_z"][1].text()
    f.write("  " + s1 + "  " + s2 + "\n") 



def JoinListStr(self, lst):
    s = ""
    for x in lst:
    s += str(x) + "   "
    return s  



def SaveFilePart(self, f, record):
    if isinstance(record, dict):
    #print("Dictionary found")
    if record["type"] == "heap":
        f.write(record["header"] + "\n")
        data = record["data"]
        for item in data:
        s = ""
        if isinstance(item, list):
            for x in item:       
            s += str(x) + "   "  
            f.write(s + "\n") 
        else:
            f.write(str(item) + "\n") 
    elif record["type"] == "params":
        strWr = ""
        for s in record["names"]:
        strWr = strWr + s + "   "
        if "title" in record:
        strWr = strWr + "!" + record["title"]
        f.write(strWr + "\n") 
        strWr = ""
        for item in record["items"]:
        strWr = strWr + item.text() + "   "
        f.write(strWr + "\n")  
        
    elif record["type"] == "paramsrow":
        for i in range(len(record["items"])):
        strWr = " " + record["items"][i].text() + "   " + record["names"][i]
        if i == 0 and "title" in record:
            strWr += "  !" + record["title"]
        f.write(strWr + "\n")                     
        
    elif record["type"] == "timed":
        n = len(record["items"])
        s = self.JoinListStr(record["names1"])
        if "title" in record:
        s += "!" + record["title"]
        f.write(s + "\n") 
        s = str(n)
        if "add" in record:
        for x in record["add"]:
            s += "  " + str(x)
        f.write(s + "\n")
        
        f.write(self.JoinListStr(record["names2"]) + "\n")
        
        for i in range(n):
        s = ""
        for item in record["items"][i]:
            s += item.text() + "  "
        f.write(s + "\n")
    
    elif record["type"] == "coil":
        s = record["name"]
        f.write(s + "\n") 
        f.write("  " + self.JoinListStr([item.text() for item in record["items_p"]]) + "\n")
        f.write("  " + self.JoinListStr([item.text() for item in record["items_g"]]) + "\n")
    
    elif record["type"] == "resist-list":
        for item in record["items"]:
        s = item.text()
        f.write("  " + s + "\n")        
    
    elif record["type"] == "set":
        for item in record["data"]:
        self.SaveFilePart(f,item)
    elif isinstance(record, list):
    for item in record:
        self.SaveFilePart(f,item)

