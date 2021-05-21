#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=RT
#SBATCH --job-name=lammps_fedoorv
#SBATCH --comment="Fedorov Lammps test"

module load gcc/9.2.0
module load mpi/openmpi4-x86_64
mkdir dir_rad
for Radius in 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 3.9 3.95 4.0 4.05 4.1 4.15 4.2;
do
	 mkdir dir_rad/rad_${Radius}
 	 cd dir_rad/rad_${Radius}
       	 cp ~/study/Project/in.obstacle ./
       	 mv in.obstacle in.obstacle_rad
       	 sed "s/RADIUS/$Radius/g" in.obstacle_rad > in.obstacle 
	 rm in.obstacle_rad
       	 srun ~/bin/lmp_mpi -in in.obstacle
	 cd ../../
done
curl -s -X POST https://api.telegram.org/bot1808164588:AAFXe23IWlAWwbxs8Du8e7gMZpQzWaRBwDA/sendMessage -d chat_id=719129171 -d text="POSCHITALOS!!!!!!!"

echo "#Radius Press_average" > Radius.txt
for   Radius in 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 3.9 3.95 4.0 4.05 4.1 4.15 4.2;
do
	Press=$(awk -f awk.sh dir_rad/rad_${Radius}/log.lammps)
	echo "${Radius} ${Press}" >> Radius.txt
done
