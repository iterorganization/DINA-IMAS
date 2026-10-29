    
import sys,argparse
import os

import DINAFiles

import xml.etree.ElementTree as ET
from xml.dom import minidom



def ControlDataToXML(directoryLoad):

    root = ET.Element("parameters")

    element = ET.SubElement(root, 'kpr')
    element.text = str(1)

    element = ET.SubElement(root, 'tpl_dir')
    element.text = str(-1.0)

    #control_data2.dat
    f = open(os.path.join(directoryLoad, "control_data2.dat"))
    
    names = ('tcont2', 'dtcont2', 'Ip_div', 'ref_ramp', 'Ip_rd', 'trd_ref', 'max_VS_lim', 'c_a_tpl2_lim', 'time_stop')
    data = DINAFiles.ReadParameters(f, 1)
    data[0][2].value *= -1.e6
    data[0][4].value *= -1.e6
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)

    f.readline()

    names = ('c_a_tpl1', 'c_a_tpl1_eob', 'c_a_tpl2', 'c_a_tpl_min', 'y0', 'c1_y0', 'c2_y0')
    data = DINAFiles.ReadParameters(f, 1)
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)
    
    f.close()


    f = open(os.path.join(directoryLoad, "tt_kavin.dat"))
    names = ('t_tran2D',)
    data = DINAFiles.ReadParameters(f, 1)
    data[0][0].value *= 1.e-3

    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)

    f.close()


    #tt_kavin2.dat
    f = open(os.path.join(directoryLoad, "tt_kavin2.dat"))
    names = ['tt_rampup']
    data = DINAFiles.ReadParameters(f, 3)
    data[0][0].value *= 1.e-3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[0][i].value)

    names = ['dt_end_sim', 'dtpl_term_l', 'cIp_end']
    data[1][2].value *= -1.e6
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[1][i].value)

    names = ['Ics1_eob', 'rms_noise']
    data[2][0].value *= -1.e3
    for i in range(len(names)):
        element = ET.SubElement(root, names[i])
        element.text = str(data[2][i].value)

    f.close()
    
    
    #control_data.dat
    f = open(os.path.join(directoryLoad, "control_data.dat"))
    names = ['Tu', 'c_cur_max']
    data = DINAFiles.ReadParameters(f, 2)
    element = ET.SubElement(root, 'Tu')
    element.text = str(data[0][-1].value)
    
    element = ET.SubElement(root, 'volt_lim')
    element.text = ""
    for i in range(len(data[0])-1):
        element.text += (str(data[0][i].value) + "  ")
    
    element = ET.SubElement(root, 'c_cur_max')
    element.text = str(data[1][0].value)

    element = ET.SubElement(root, 'curr_lim')
    element.text = ""
    for i in range(1, len(data[1])):
        element.text += (str(data[1][i].value) + "  ")

    f.close()

    return root





def main():
    # MANAGEMENT OF INPUT ARGUMENTS
    # ------------------------------
    parser = argparse.ArgumentParser(description=\
            'Converts KMC input *.dat files to XML code parameters file')
    parser.add_argument('-w','--workdir', help='The directory with input *.dat files', required=True)
    parser.add_argument('-n','--newdir', help='The directory for output codeparam_kmc.xml', required=False)

    args = vars(parser.parse_args())


    path_in = args['workdir']

    # Database name
    if args['newdir'] != None:
        path_out = args['newdir']
    else:
        path_out = path_in


    root = ControlDataToXML(path_in)


    xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
    f = open(os.path.join(path_out, "codeparam_kmc.xml"), 'w')
    f.write(xmlstr)
    f.close()   
  


if __name__ == '__main__':  # If direct run, not import
    main()
