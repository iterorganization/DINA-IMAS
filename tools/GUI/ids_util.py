
import sys
import math
import imas # UAL library
import matplotlib
#matplotlib.use('Qt5Agg')
#matplotlib.use('GTK3Agg')

import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
from itertools import cycle
import numpy as np



def GetGeometryPath(geom):
  verts = []
  codes = []
  
  if (geom.geometry_type == 2):
    verts = [
      (geom.rectangle.r - 0.5*geom.rectangle.width, geom.rectangle.z - 0.5*geom.rectangle.height),  # left, bottom
      (geom.rectangle.r - 0.5*geom.rectangle.width, geom.rectangle.z + 0.5*geom.rectangle.height),  # left, top
      (geom.rectangle.r + 0.5*geom.rectangle.width, geom.rectangle.z + 0.5*geom.rectangle.height),  # right, top
      (geom.rectangle.r + 0.5*geom.rectangle.width, geom.rectangle.z - 0.5*geom.rectangle.height),  # right, bottom
      (0., 0.),  # ignored
    ]
    codes = [
        Path.MOVETO,
        Path.LINETO,
        Path.LINETO,
        Path.LINETO,
        Path.CLOSEPOLY,
    ]
    path = Path(verts, codes)
    return path
  
  elif (geom.geometry_type == 3):
    
    dr1 = geom.oblique.length_alpha*math.cos(geom.oblique.alpha)
    dz1 = geom.oblique.length_alpha*math.sin(geom.oblique.alpha)
    
    dr2 =-geom.oblique.length_beta*math.sin(geom.oblique.beta)
    dz2 = geom.oblique.length_beta*math.cos(geom.oblique.beta)
    
    
    verts = [
      (geom.oblique.r, geom.oblique.z),  # left, bottom
      (geom.oblique.r + dr1, geom.oblique.z + dz1),  # right, bottom
      (geom.oblique.r + dr1 + dr2, geom.oblique.z + dz1 + dz2),  # right, top
      (geom.oblique.r + dr2, geom.oblique.z + dz2),  # left, top
      (0., 0.),  # ignored
    ]
    
    #verts = [
      #(geom.oblique.r, geom.oblique.z),  # left, bottom
      #(geom.oblique.r + geom.oblique.length_alpha*math.cos(geom.oblique.alpha),
        #geom.oblique.z + geom.oblique.length_alpha*math.sin(geom.oblique.alpha)),  # left, top
      #(geom.oblique.r + geom.oblique.length_alpha*math.cos(geom.oblique.alpha) -  geom.oblique.length_beta*math.sin(geom.oblique.beta),
        #geom.oblique.z + geom.oblique.length_alpha*math.sin(geom.oblique.alpha) +  geom.oblique.length_beta*math.cos(geom.oblique.beta)),  # right, bottom
      #(geom.oblique.r - geom.oblique.length_beta*math.sin(geom.oblique.beta),
        #geom.oblique.z + geom.oblique.length_beta*math.cos(geom.oblique.beta)),  # right, top
      #(0., 0.),  # ignored
    #]
    codes = [
        Path.MOVETO,
        Path.LINETO,
        Path.LINETO,
        Path.LINETO,
        Path.CLOSEPOLY,
    ]
    path = Path(verts, codes)
    return path
  
  elif (geom.geometry_type == 1):
    n = len(geom.outline.r)
    for i in range(n):
      verts.append((geom.outline.r[i], geom.outline.z[i]))
      codes.append(Path.LINETO)
      
    if (n > 0):
      codes[0] = Path.MOVETO
      
      verts.append((0.0, 0.0))
      codes.append(Path.CLOSEPOLY)
    
    path = Path(verts, codes)
    return path
    
  elif (geom.geometry_type == 5):
    #print(dir(patches))
    #width = geom.annulus.radius_outer - geom.annulus.radius_inner
    circle_out = Path.circle([geom.annulus.r, geom.annulus.z], geom.annulus.radius_outer);
    circle_in = Path.circle([geom.annulus.r, geom.annulus.z], geom.annulus.radius_inner);
    vertices = circle_in.vertices[::-1]
    codes = circle_in.codes
    circle_in = Path(vertices, codes)
    circle = Path.make_compound_path(circle_out, circle_in)
    # Get the path and the affine transformation
    #path = circle.get_path()
    #transform = circle.get_transform()
    
    # Now apply the transform to the path
    #newpath = transform.transform_path(path)
    return circle
  else:
    print('Geometry type ' + str(geom.geometry_type))
  path = Path(verts, codes)
  return path


def plot_pf_active(ax, ids, facecolor='orange', edgecolor='blue'):
    for icoil in range(len(ids.coil)):
      coil = ids.coil[icoil]
      for ielem in range(len(coil.element)):
        elem = coil.element[ielem]
        path = GetGeometryPath(elem.geometry)
        #patch = patches.PathPatch(path, facecolor=facecolor, edgecolor=facecolor, lw=2)
        #ax.add_patch(patch)
        for pol in path.to_polygons():
          x_val = [x[0] for x in pol]
          y_val = [x[1] for x in pol]
          x_mid = np.mean(x_val[0:-1])
          y_mid = np.mean(y_val[0:-1])
          ax.plot(x_val,y_val,'b',linewidth=1.5)
          
          #ax.plot(x_mid,y_mid,'b.',linewidth=1.5)
          
          if len(x_val) == 5:
            ax.plot([x_val[0], x_val[2]], [y_val[0], y_val[2]],'b',linewidth=1.)
            ax.plot([x_val[1], x_val[3]], [y_val[1], y_val[3]],'b',linewidth=1.)


          #if (len(coil.element) > 1):
            #text = str(icoil+1) + '/' + str(ielem+1)
          #else:
            #text = str(icoil+1)
          #txt = ax.annotate(text, xy=(x_mid, y_mid), fontsize = 16, color='r')
          #txt.draggable()
          

        
def plot_pf_passive(ax, ids, facecolor=(0.8, 0.8, 0.8), edgecolor=(0, 0, 1)):
    prop_cycle = plt.rcParams['axes.prop_cycle']
    colors = cycle(prop_cycle.by_key()['color'])
    for loop in ids.loop:
      facecolor = next(colors)
      edgecolor = (0,0,0)
      for elem in loop.element:
        path = GetGeometryPath(elem.geometry)
        #if elem.turns_with_sign < 0.:
          #facecolor = (0, 0.5, 0.5)
        #else:
          #facecolor = (0.5, 0.5, 0)
        
        patch = patches.PathPatch(path, facecolor=facecolor, edgecolor=edgecolor)
        ax.add_patch(patch)
        
        
def plot_limiter(ax, ids, color='k-'):
    if (len(ids.description_2d) > 0):
      line = None
      for unit in ids.description_2d[0].limiter.unit:
        line, = ax.plot(unit.outline.r, unit.outline.z, color, linewidth=1)
      if line is not None:
        line.set_label('limiter')
    else:
      print("No limiter data in given IDS")
          
          

def GetIDS(meta, idslist):
    imas_entry_init = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND, meta["database"], meta["shot"], meta["run"], meta["user"], data_version = '3')
    imas_entry_init.open()
    
    if (isinstance(idslist, dict)):
      out = {}
      for key in idslist:
        out[key] = imas_entry_init.get(key)
      
    if (isinstance(idslist, list)):
      out = {}
      for it in idslist:
        out[it] = imas_entry_init.get(it)
      
    elif (isinstance(idslist, str)):
      out = imas_entry_init.get(idslist)
        
    imas_entry_init.close()
    return out

    