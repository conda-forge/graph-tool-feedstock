import faulthandler
if not faulthandler.is_enabled():
    faulthandler.enable()

import numpy
import numpy.linalg
import scipy
import scipy.linalg
import cairo
import gi
import gi.repository
import matplotlib
import graph_tool
import graph_tool.all
import graph_tool.draw
import graph_tool.draw.cairo_draw
