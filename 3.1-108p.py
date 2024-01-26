import numpy as np
import matplotlib.pyplot as plt

a=np.array([4,3])

fig=plt.figure()

ax=fig.add_subplot(1,1,1)
ax.scatter(a[0],a[1],s=30)

ax.text(a[0]+0.2, a[1]+0.2, 'a', size=15)

ax.set_xticks(range(-5,6))
ax.set_yticks(range(-5,6))

ax.grid()
ax.set_axisbelow(True)

ax.set_aspect('equal',adjustable='box')

ax.spines['left'].set_position('zero')
ax.spines['bottom'].set_position('zero')

ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')

plt.show()