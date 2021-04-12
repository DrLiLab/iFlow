#!/usr/bin/env python3
import re
import sys
import os
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Removes PROPERTY LEF58_SPACING from lef files')
parser.add_argument('--inputLyt', '-i', required=True,
                    help='Input Lyt')
parser.add_argument('--lefs',     '-l', required=True,
                    help='Input Lef')
parser.add_argument('--outputLyt', '-o', required=True,
                    help='Output Lef')
args = parser.parse_args()


print(os.path.basename(__file__),": Insert lefs into lyt file of klayout")

f = open(args.inputLyt)
content = f.read()
f.close()

pattern = r"<lef-files>.*</lef-files>"
replace = re.sub(r'\s+','</lef-files>\n    <lef-files>','<lef-files>'+args.lefs+'</lef-files>')

result = re.sub(pattern, replace, content)

f = open(args.outputLyt, "w")
f.write(result)
f.close()

print(os.path.basename(__file__),": Finished")

