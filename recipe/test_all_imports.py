import faulthandler
faulthandler.enable()

import graph_tool
import graph_tool.all as gt
import graph_tool.draw
import graph_tool.draw.cairo_draw


g = gt.Graph()
v0 = g.add_vertex()
v1 = g.add_vertex()
v2 = g.add_vertex()

g.add_edge(v0, v1)
g.add_edge(v1, v2)
g.add_edge(v2, v0)

v = gt.pagerank(g)

gt.graph_draw(g, vertex_color=v, output="test.png")
