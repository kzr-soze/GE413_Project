## Modeling Wi-Fi Signal Interference for Municipal Wireless Network Planning <br />
Nirmal Prakash, Steven Plutchak, and Timothy Murray

----------------
Functions
----------------
- deployRandRouters: For given topography and number of routers k, initialize random router positions and return row vector of coordinates, with all x coordinates first, followed by y coordinates. 

- routerCost: Apply cost function to given router set, topography, base cost, and cost multiplier.

- squaresCovered: Calculates number of calculated nodes (squares) for a given router set, topography, router range, traffic, and high QoS importance factor. Router set accepted as vector input of all x values first followed by all y values. Calls subfunction coverage.

	- coverage: Determines which nodes in a given router set, topography, and range are covered, and returns two m x n matrices: frontier (boolean matrix describing coverage at each point, 1 if yes and -1 if no), and distances (distance to nearest router at each node, incorporating the importance factor and traffic). Calls subfunction rNeighbors.

		- rNeighbors: Performs calculation of frontier and distances matrices described above.

- topo2rgb: Accepts topography matrix (values ranged -1 to 2) and converts to RGB format for use with imshow.


----------------
Scripts
----------------
- Main: Initializes random vector set and calls genetic algorithm optimization.

- mapsize: Resampled the full-size topography map to 3 smaller sizes (1/4, 1/3, 1/2).

- map_prep/Map_Format_BuildingHighlights.m: Initial processing of Chicago Loop map into usable matrix, which was then output to Excel for manual touch-ups.