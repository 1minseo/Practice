import numpy as np
import matplotlib.pyplot as plt

# 3차원 그래프를 그리기 위해 추가해야 하는 모듈
from mpl_toolkits.mplot3d import Axes3D

# 3차원 벡터 a
a=np.array([4,5,6])

fig=plt.figure()

ax=fig.add_subplot(1,1,1,projection='3d') #서브플롯에서 3차원 좌표계 사용

# a[0]은 x좌표, a[1]은 y좌표, a[2]은 z좌표
ax.quiver(0,0,0,a[0],a[1],a[2], color='black', arrow_length_ratio=0.1) #시작점이 (0, 0, 0)

# x, y, z좌표축 범위가 0~8인 그리드 생성
ax.set_xlim(0,8)
ax.set_ylim(0,8)
ax.set_zlim(0,8)
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.view_init(elev=20, azim=5)
ax.grid()
ax.set_axisbelow(True)
ax.set_aspect('equal', adjustable='box')

plt.show()