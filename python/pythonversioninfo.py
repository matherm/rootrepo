import sys
from contextlib import suppress

with suppress(Exception):
    import numpy
    import torch
    import torchvision

    print("SYSTEM INFORMATION (", socket.gethostname(),")" )
    print("---------------------------------")
    print("%x" % sys.maxsize, sys.maxsize > 2**32)
    print("Platform:", platform())
    print("ummon3:", version)
    print("Python:", sys.version.split('\n'))
    print("CuDNN:", torch.backends.cudnn.version())
    print("CUDA:", torch.version.cuda) 
    print("Torch:", torch.__version__)
    print("Torchvision",torchvision.__version__)
    print("Numpy:", numpy.version.version)
    numpy.__config__.show()
    print("---------------------------------")