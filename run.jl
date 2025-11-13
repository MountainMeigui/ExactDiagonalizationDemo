# 1. Import Pkg to manage environment
using Pkg

# 2. Activate and install dependencies
Pkg.activate(".")
Pkg.instantiate()

# 3. Load the module
using ExactDiagonalizationDemo

# 4. Put the actual "running" logic here
println("Computing spectrum...")
p = compute_spectrum_vs_M(0, 8, 3, 1.0, 0.1, n_states=8)

# 5. Display the plot
# (This might pop up a window or print to the terminal)
display(p)

# 6. Save the plot
println("Saving plot to spectrum.png...")
save_spectrum_plot(1, 9, 3, 1.0, 0.1, filename="spectrum.png", n_states=8)

println("Done!")
