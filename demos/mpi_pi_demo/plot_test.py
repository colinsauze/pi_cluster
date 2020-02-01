import matplotlib
import matplotlib.pyplot as plt
import numpy as np


x = np.float32(np.random.uniform(size=10000))
y = np.float32(np.random.uniform(size=10000))

fig, ax = plt.subplots()

plt.scatter(x,y,s=0.5,c='blue')

circle = matplotlib.patches.Circle((0,0), radius=1,edgecolor='r',fill=False)
ax.add_patch(circle)

plt.xlim(0,1.01)
plt.ylim(0,1.01)

plt.show()
