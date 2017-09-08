#!/usr/bin/env python

""" This module runs toposub_gridTS.R
 
Example:   
      as import: 


Attributes:$gridpath $Nclust $file1 $targV

Todo:

"""
path2script = "./rsrc/toposub_gridTS.R"

# main
def main(gridpath, Nclust, file1, targV):
    """Main entry point for the script."""
    run_rscript_fileout(path2script,[gridpath, Nclust, file1, targV])

# functions
def run_rscript_stdout(path2script , args):
    """ Function to define comands to run an Rscript. Returns an object. """
    import subprocess
    command = 'Rscript'
    cmd     = [command, path2script] + args
    print("Running:" + str(cmd))
    x = subprocess.check_output(cmd, universal_newlines=True)
    return(x)

def run_rscript_fileout(path2script , args):
    """ Function to define comands to run an Rscript. Outputs a file. """
    import subprocess
    command = 'Rscript'
    cmd     = [command, path2script] + args
    print("Running:" + str(cmd))
    subprocess.check_output(cmd)
 
# calling main
if __name__ == '__main__':
    import sys
    gridpath           = sys.argv[1]
    Nclust         = sys.argv[2]
    file1   = sys.argv[3]
    targV   = sys.argv[4]

    main(gridpath, Nclust, file1, targV)
