# Set the output to a png file
set terminal png size 800,400
set samples 1000
#set xtics 128
#set logscale y 10
# The file we'll write to
set output 'figure-ipc.png'
# The graphic title
set title 'Random walk - IPC'
# Set range
set yrange [ 0 : 4 ]
# Set the legend location
set key outside
# Set lables
set xlabel "Matrix size"
set ylabel "Instructions per cycle"
#plot the graphic
plot "ipc0.txt" using 1:2 with lines ti "version 0", \
"ipc1.txt" using 1:2 with lines ti "version 1", \
"ipc1-opt.txt" using 1:2 with lines ti "version 1 - optimized"
