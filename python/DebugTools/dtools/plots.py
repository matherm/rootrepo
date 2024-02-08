import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def plot_theta(theta, fname="/home/mhermann/interp_coeffs.png"):
	plt.figure()
	plt.title("Regression coefficients W")
	for i in range(len(theta)):
	plt.plot(theta[i].real.get(), theta[i].imag.get(), 'o', label=f"Sx {i}")
	plt.legend()
	plt.ylabel("Im")
	plt.xlabel("Re")
	plt.savefig()
