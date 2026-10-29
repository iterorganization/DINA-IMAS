import os, argparse
import math
import imas




def ReadElementData(f):
    output = {}
    
    output["name"] = f.readline().strip()
    
    s = f.readline().strip().split()
    props = [int(p) for p in s]
    if len(props) != 4:
        print("Incorrect properties size: " + str(len(props)))
    output["props"] = props
    
    s = f.readline().strip().split()
    geometry = [float(p) for p in s]
    if len(geometry) != 6:
        print("Incorrect geometry items size: " + str(len(geometry)))     
    output["geometry"] = geometry

    return output


def FillIDSElement(elem, d):
    elem.name = d['name']
    elem.turns_with_sign = float(d['props'][2])

    geometry = d['geometry']
    r = geometry[0]
    z = geometry[1]
    dr = geometry[2]
    dz = geometry[3]
    beta = geometry[4] - math.pi/2.
    alpha = geometry[5]

    tol = 1.e-8
    if abs(alpha) < tol and abs(beta) < tol:
        elem.geometry.geometry_type = 2
        elem.geometry.rectangle.r = r
        elem.geometry.rectangle.z = z
        elem.geometry.rectangle.width = dr
        elem.geometry.rectangle.height = dz
    else:
        elem.geometry.geometry_type = 3
        elem.geometry.oblique.r = r - 0.5*(dr*math.cos(alpha) + dz*math.sin(beta))
        elem.geometry.oblique.z = z - 0.5*(dr*math.sin(alpha) + dz*math.cos(beta))
        elem.geometry.oblique.length_alpha = dr
        elem.geometry.oblique.length_beta = dz
        elem.geometry.oblique.alpha = alpha
        elem.geometry.oblique.beta = beta


def IDSElementData(elem):
    name = elem.name
    p = [1, 1, elem.turns_with_sign, 0]

    if elem.geometry.geometry_type == 2:
        r = elem.geometry.rectangle.r
        z = elem.geometry.rectangle.z
        dr = elem.geometry.rectangle.width
        dz = elem.geometry.rectangle.height
        beta = 0.0
        alpha = 0.0
    elif elem.geometry.geometry_type == 3:
        dr = elem.geometry.oblique.length_alpha
        dz = elem.geometry.oblique.length_beta
        alpha = elem.geometry.oblique.alpha
        beta = elem.geometry.oblique.beta
        r = elem.geometry.oblique.r + 0.5*(dr*math.cos(alpha) + dz*math.sin(beta))
        z = elem.geometry.oblique.z + 0.5*(dr*math.sin(alpha) + dz*math.cos(beta))
    else:
        print("Unsupported element geometry type=" + str(elem.geometry.geometry_type))

    geometry = [r, z, dr, dz, beta + math.pi/2., alpha]

    return name, p, geometry


def ReadTokamakConfig(f):
    ids_factory = imas.IDSFactory()

    pf_active = ids_factory.pf_active()
    pf_passive = ids_factory.pf_passive()
    wall = ids_factory.wall()
    magnetics = ids_factory.magnetics()

    pf_active.ids_properties.homogeneous_time = 0
    pf_passive.ids_properties.homogeneous_time = 0
    wall.ids_properties.homogeneous_time = 0
    magnetics.ids_properties.homogeneous_time = 0
    

    # Coils
    data = []
    f.readline()
    nae = int(f.readline())
    
    print("nae = " + str(nae))
    for i in range(nae):
        data.append(ReadElementData(f))
    
    npfa = 0
    for d in data:
        npfa = max(npfa, d['props'][3])

    pf_active.coil.resize(npfa)
    for d in data:
        icoil = d['props'][3]-1
        elem = pf_active.coil[icoil].element.getAoSElement()
        pf_active.coil[icoil].element.append(elem)
        FillIDSElement(elem, d)

    
    # Coil resistances
    data = []
    f.readline()
    nres = int(f.readline())
    if nres != npfa:
        print("Incorrect amount of coil resistances: nr=" + str(nres) + ", npfa="+ str(npfa))
    for i in range(nres):
        line = f.readline().rstrip()
        description = line.split()
        pf_active.coil[i].resistance = float(description[0])
    

    # Vessel
    data = []
    f.readline()
    nae = int(f.readline())
    
    print("nae = " + str(nae))
    for i in range(nae):
        data.append(ReadElementData(f))
    
    npfa = 0
    for d in data:
        npfa = max(npfa, d['props'][3])

    pf_passive.loop.resize(npfa)
    for d in data:
        icoil = d['props'][3]-1
        elem = pf_passive.loop[icoil].element.getAoSElement()
        pf_passive.loop[icoil].element.append(elem)
        FillIDSElement(elem, d)

    
    # Vessel resistances
    data = []
    f.readline()
    nres = int(f.readline())
    if nres != npfa:
        print("Incorrect amount of coil resistances: nr=" + str(nres) + ", npfa="+ str(npfa))
    for i in range(nres):
        line = f.readline().rstrip()
        description = line.split()
        pf_passive.loop[i].resistance = float(description[0])
    


    # Loops
    f.readline()
    nloop = int(f.readline())
    print("nloop = " + str(nloop))
    for i in range(nloop):
        line = f.readline().strip().split()
        loop = magnetics.flux_loop.getAoSElement()
        magnetics.flux_loop.append(loop)
        loop.position.resize(1)
        loop.position[0].r = float(line[0])
        loop.position[0].z = float(line[1])
    
    
    # Probes
    f.readline()
    line = f.readline().strip().split()
    nprob = int(line[0])
    print("nprob = " + str(nprob))
    for i in range(nprob):
        line = f.readline().strip().split()
        probe = magnetics.b_field_pol_probe.getAoSElement()
        magnetics.b_field_pol_probe.append(probe)
        probe.position.r = float(line[0])
        probe.position.z = float(line[1])
        probe.poloidal_angle = float(line[2])
        probe.length = float(line[3])
    
    
    # Limiter
    f.readline()
    nlim = int(f.readline())
    print("nlim = " + str(nlim))
    wall.description_2d.resize(1)
    wall.description_2d[0].limiter.unit.resize(1)
    outline = wall.description_2d[0].limiter.unit[0].outline
    outline.r.resize(nlim)
    outline.z.resize(nlim)
    for i in range(nlim):
        line = f.readline().strip().split()
        outline.r[i] = float(line[0])
        outline.z[i] = float(line[1])
    


    # Area
    f.readline()
    line = f.readline().strip().split()
    rmin = float(line[0])
    rmax = float(line[1])
    line = f.readline().strip().split()
    zmin = float(line[0])
    zmax = float(line[1])
    
    
    return pf_active, pf_passive, wall, magnetics



def SaveTokamakConfig(pf_active, pf_passive, wall, magnetics, f):
    
    # Coils
    f.write("COIL   number:   nelem \n")

    nae = 0
    for coil in pf_active.coil:
        nae += len(coil.element)
    f.write(str(nae) + "\n")
    for i in range(len(pf_active.coil)):
        coil = pf_active.coil[i]
        for elem in coil.element:
            name, props, geometry = IDSElementData(elem)
            f.write(name + "\n")
            s = "%d  %d  %f  %d \n"%(props[0], props[1], props[2], i+1)
            f.write(s)
            s = "%e  %e  %e  %e  %e  %e \n"%(geometry[0], geometry[1], geometry[2], geometry[3], geometry[4], geometry[5])
            f.write(s)
    f.write("res_PF:   npf \n")  
    f.write(str(len(pf_active.coil)) + "\n")
    for i in range(len(pf_active.coil)):
        f.write(str(pf_active.coil[i].resistance) + "\n")
    

    # Vessel
    f.write("Vessel   number:   nelem \n")
    nae = 0
    for loop in pf_passive.loop:
        nae += len(loop.element)
    f.write(str(nae) + "\n")
    for i in range(len(pf_passive.loop)):
        loop = pf_passive.loop[i]
        for elem in loop.element:
            name, props, geometry = IDSElementData(elem)
            f.write(name + "\n")
            s = "%d  %d  %f  %d \n"%(props[0], props[1], props[2], i+1)
            f.write(s)
            s = "%e  %e  %e  %e  %e  %e \n"%(geometry[0], geometry[1], geometry[2], geometry[3], geometry[4], geometry[5])
            f.write(s)
    f.write("res_VES:   ncam \n")  
    f.write(str(len(pf_passive.loop)) + "\n")
    for i in range(len(pf_passive.loop)):
        f.write(str(pf_passive.loop[i].resistance) + "\n")

    
    
    # Loops
    nloop = len(magnetics.flux_loop)
    f.write("Loops   number:   kloop  \n") # comment
    f.write(str(nloop) + "\n") # nloop
    for i in range(nloop):
        loop = magnetics.flux_loop[i]
        s1 = str(loop.position[0].r)
        s2 = str(loop.position[0].z)
        f.write("  " + s1 + "  " + s2 + "\n")
    
    
    # Probes
    nprobes = len(magnetics.b_field_pol_probe)
    f.write("Probes   number   and   division:   kprobe   kpb \n") # comment
    f.write(str(nprobes) + "  " + str(1) + "\n") # nprobes, subdivisions
    for i in range(nprobes):
        probe = magnetics.b_field_pol_probe[i]
        s1 = str(probe.position.r)
        s2 = str(probe.position.z)
        s3 = str(probe.poloidal_angle)
        s4 = str(probe.length)
        f.write("  " + s1 + "  " + s2 + "  " + s3 + "  " + s4 + "\n")


    rmin = 0.
    rmax = 1.e6
    zmin = -1.e6
    zmax = 1.e6
    # Limiter
    outline = wall.description_2d[0].limiter.unit[0].outline
    nlim = len(outline.r)
    rmin = min(outline.r)
    rmax = max(outline.r)
    zmin = min(outline.z)
    zmax = max(outline.z)
    f.write("Limiter   number:   n_limiter  \n") # comment
    f.write(str(nlim) + "\n") # nlim
    for i in range(nlim):
        s1 = str(outline.r[i])
        s2 = str(outline.z[i])
        f.write("  " + s1 + "  " + s2 + "\n")
    
    
    # Area
    dz = zmax - zmin
    f.write("area - R(1) R(2) Z(1) Z(2)" + "\n")
    s1 = str(rmin*0.9)
    s2 = str(rmax*1.1)
    f.write("  " + s1 + "  " + s2 + "\n")
    s1 = str(zmin - dz*0.1)
    s2 = str(zmax + dz*0.1)
    f.write("  " + s1 + "  " + s2 + "\n") 


    return


def main():
    # MANAGEMENT OF INPUT ARGUMENTS
    # ------------------------------
    parser = argparse.ArgumentParser(description=\
          '---- Converts machine data in DINA format, tokamak_config.dat file, to IDS')
    parser.add_argument('-f','--file',help='Name of a file with machine configuration', required=True)
    parser.add_argument('-u','--uri',help='URI of IMAS database to put output IDS',required=True)
    parser.add_argument('-a','--action',help='read (r) or write (w)',required=True)


    args = vars(parser.parse_args())

    filename = args["file"]
    uri  = args["uri"]
    if args["action"] == 'r':
        act = 'r'
    elif args["action"] == 'w':
        act = 'w'
    else:
        print("Action must be on of 'r' or 'w'")
  
    if act == 'r':
        with open(filename, 'rt') as f:
            pf_active, pf_passive, wall, magnetics = ReadTokamakConfig(f)

        with imas.DBEntry(uri, 'w') as imas_obj1:
            imas_obj1.put(pf_active)
            imas_obj1.put(pf_passive)
            imas_obj1.put(magnetics)
            imas_obj1.put(wall)



    if act == 'w':

        with imas.DBEntry(uri, 'r') as imas_obj1:
            pf_active = imas_obj1.get('pf_active')
            pf_passive = imas_obj1.get('pf_passive')
            magnetics = imas_obj1.get('magnetics')
            wall = imas_obj1.get('wall')


        with open(filename, 'wt') as f:
            SaveTokamakConfig(pf_active, pf_passive, wall, magnetics, f)




if __name__ == '__main__':  # If direct run, not import
  main()
