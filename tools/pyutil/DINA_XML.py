    
import sys,argparse
import os

import DINAFiles

import xml.etree.ElementTree as ET
from xml.dom import minidom



def DINADataToXML(directoryLoad):

    root = ET.Element("parameters")

    f = open(os.path.join(directoryLoad, "kpr.dat"))
    names = ('kpr',)
    data = DINAFiles.ReadParameters(f, 1)
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    # tt_kavin.dat
    f = open(os.path.join(directoryLoad, "tt_kavin.dat"))
    names = ('tt_kavin',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #tran_times.dat
    f = open(os.path.join(directoryLoad, "tran_times.dat"))
    names = ('tt_dina',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #tay_simul.dat
    f = open(os.path.join(directoryLoad, "tay_simul.dat"))
    names = ('tau_sim',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()

    #dw.dat
    f = open(os.path.join(directoryLoad, "dw.dat"))
    names = ('tau_dw',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #for002_kav
    f = open(os.path.join(directoryLoad, "for002_kav"))
    names = ('tau', 'rs0', 'key_t11', 'bt0')
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3
    data[0][1].value *= 1.e-2
    data[0][3].value *= 1.e-1
    for i in (0, 2):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #bohm_gbohm.dat
    f = open(os.path.join(directoryLoad, "bohm_gbohm.dat"))
    names = ('bohm_gbohm',)
    data = DINAFiles.ReadParameters(f, 1)
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #init.dat
    f = open(os.path.join(directoryLoad, "init.dat"))
    names = ('p', 'T_e', 'T_i', 'gam', 'gain_puff')
    data = DINAFiles.ReadParametersCol(f, 5)
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #pcchp_end.dat
    f = open(os.path.join(directoryLoad, "pcchp_end.dat"))
    names = ('pcchp_end',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e19
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()



    #transp_ext.dat
    f = open(os.path.join(directoryLoad, "transp_ext.dat"))
    names = ('ener_ext', 'dens_ext', 'ajb_ext')
    data = DINAFiles.ReadParameters(f, 1)
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    f.close()


    #tt_kavin2.dat
    f = open(os.path.join(directoryLoad, "tt_kavin2.dat"))
    data = DINAFiles.ReadParameters(f, 3)
    
    names = ['tt_rampup']
    data[0][0].value *= 1.e-3
    for i in []:
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)

    names = ['dt_end_sim', 'dtpl_term_l', 'cIp_end']
    data[1][2].value *= -1.e6
    for i in [2]:
        element = ET.SubElement(root, names[i])
        element.text = str(data[1][i].value)

    names = ['Ics1_eob', 'rms_noise']
    data[2][0].value *= -1.e3
    for i in [0]:
        element = ET.SubElement(root, names[i])
        element.text = str(data[2][i].value)

    f.close()
    

    # Add
    element = ET.SubElement(root, "grid_n")
    element.text = str(50)
    
    element = ET.SubElement(root, "grid_rho")
    element.text = str(0.5)

    element = ET.SubElement(root, "grid_alpha")
    element.text = str(0.95)

    element = ET.SubElement(root, "coef_p_lh")
    element.text = str(1.0)

    element = ET.SubElement(root, "q_swth")
    element.text = str(0.97)

    element = ET.SubElement(root, "tpl_dir")
    element.text = str(-1.0)

    # Gaps
    fr = open(os.path.join(directoryLoad, 'gaps_data_ramp'), 'r')
    fr.readline()
    s_ng = fr.readline().strip()
    fr.readline()
    s_gr = fr.readline().strip()
    fr.readline()
    s_gz = fr.readline().strip()
    fr.close()

    ng = int(s_ng)
    gr = [float(g)*1.e-2 for g in s_gr.split()]
    gz = [float(g)*1.e-2 for g in s_gz.split()]

    # Remove g3 and g6
    if ng == 6:
        gr = [gr[i] for i in [0, 1, 3, 4]]
        gz = [gz[i] for i in [0, 1, 3, 4]]
        ng = 4

    s_gr = "  ".join([str(g) for g in gr])
    s_gz = "  ".join([str(g) for g in gz])

    element_g = ET.SubElement(root, "gaps")
    element_ng = ET.SubElement(element_g, "ngaps")
    element_ng.text = str(ng)
    element_gr = ET.SubElement(element_g, "gaps_r")
    element_gr.text = s_gr
    element_gz = ET.SubElement(element_g, "gaps_z")
    element_gz.text = s_gz

    # Circuit
    element_c = ET.SubElement(root, "circuit")
    element_nc = ET.SubElement(element_c, "ncirc")
    element_nc.text = "14"
    element_con = ET.SubElement(element_c, "connection")
    element_con.text = "1 2 3 3 4 5 6 7 8 9 10 11 12 12"
    element_dir = ET.SubElement(element_c, "direction")
    element_dir.text = "1 1 1 1 1 1 1 1 1 1 1 1 1 -1"


    return root





def main():
    # MANAGEMENT OF INPUT ARGUMENTS
    # ------------------------------
    parser = argparse.ArgumentParser(description=\
            'Converts DINA input *.dat files to XML code parameters file')
    parser.add_argument('-w','--workdir', help='The directory with input *.dat files', required=True)
    parser.add_argument('-n','--newdir', help='The directory for output codeparam_dina.xml', required=False)

    args = vars(parser.parse_args())


    path_in = args['workdir']

    # Database name
    if args['newdir'] != None:
        path_out = args['newdir']
    else:
        path_out = path_in


    root = DINADataToXML(path_in)


    xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
    f = open(os.path.join(path_out, "codeparam_dina.xml"), 'w')
    f.write(xmlstr)
    f.close()   
  


if __name__ == '__main__':  # If direct run, not import
    main()
