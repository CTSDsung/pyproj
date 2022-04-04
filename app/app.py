from flask import Flask
import matplotlib.pyplot as plot
import numpy as np
app = Flask(__name__)

@app.route('/')
def hello_world():
    x = np.linspace(0, 20, 100)  # Create a list of evenly-spaced numbers over the range
    plot.plot(x, np.sin(x))      # Plot the sine of each x point
    return 'Hello from Python, Docker!'
