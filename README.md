GE 413 Project
S. Cai, T. Murray

----------------
Functions
----------------
- deployRandRouters: for given topography and number of routers k, initialize random router positions and return row vector of coordinates, with all x coordinates first, followed by y coordinates. 

- routerCost: apply cost function to given router set, topography, base cost, and cost multiplier.

- squaresCovered: calculates number of calculated nodes (squares) for a given router set, topography, router range, and high QoS importance factor. Router set accepted as vector input of all x values first followed by all y values. Calls subfunction coverage.

-- coverage: determines which nodes in a given router set, topography, and range are covered, and returns two m x n matrices: frontier (boolean matrix describing coverage at each point, 1 if yes and -1 if no), and distances (distance to nearest router at each node, incorporating the importance factor). Calls subfunction rNeighbors.

--- rNeighbors: performs calculation of frontier and distances matrices described above.

- topo2rgb: accepts topography matrix (values ranged -1 to 2) and converts to RGB format for use with imshow.


----------------
Scripts
----------------
- Main: initializes random vector set and calls genetic algorithm optimization.

- mapsize: resampled the full-size topography map to 3 smaller sizes (1/4, 1/3, 1/2).

- map_prep/mapprep.m: initial processing of UIUC campus map into usable matrix, which was then output to Excel for manual touch-ups.