import os, sys
import argparse
import io
import json

## trying not to use f-strings so everything is compatible with old python versions
parser = argparse.ArgumentParser(description="Automatically generates documentation reference for a uobjrtl")
parser.add_argument("name", type=str, help="The full name of the uobjrtl (e.g. Cryptography)")
parser.add_argument("abbrev", type=str, help="The abbreviated name of the uobjrtl (e.g. crypto)")
args = parser.parse_args()

manifest_path = os.path.join(os.path.dirname(__file__), 
                    "..", "..", "uobjrtl", args.abbrev, 
                    "uberspark.json"
                )

if not os.path.exists(manifest_path):
    print("Error, can't find manifest file: ")
    print(manifest_path)
    sys.exit(1)

func_names = []

# remove comments from json so python can interpret it
with open(manifest_path, "r") as j:
    manifest = io.StringIO()
    for line in j:
        if "/*" in line:
            while not "*/" in line:
                line = next(j)
        else:
            manifest.write(line.strip())
    manifest.seek(0)
    data = json.loads(str(manifest.read()))

# get all function names
modules = data["uberspark-uobjrtl"]["modules-spec"]
for module in modules:
    for funcs in module["module-funcdecls"]:
        name = funcs["funcname"]
        func_names.append(name)

docs_path = os.path.join(os.path.dirname(__file__), 
                "..", "..", "..", "docs", 
                "nextgen-toolkit", "reference", "uobjrtl"
            )

# add link to intro
with open(os.path.join(docs_path , "intro.rst"), "a", encoding="utf-8-sig") as f:
    f.write("   " + args.name.capitalize() + " (" + args.abbrev + ") <" + args.abbrev + ".rst>\n")

# create and write to reference documentation file
with open(os.path.join(docs_path, args.abbrev + ".rst"), "w+", encoding="utf-8-sig") as f:
    f.write(".. include:: /macros.rst\n")
    f.write("\n\n")
    f.write(".. _uobjrtl-" + args.abbrev + ":")
    f.write("\n\n")
    header = "|uspark| |uobj| " + args.name.capitalize() + " Runtime Library"
    f.write(header + "\n")
    f.write("=" * len(header) + "\n\n")
    
    f.write("<REPLACE WITH DESCRIPTION OF THIS UOBJRTL>\n")
    f.write("The |uobj| " + args.name.capitalize() + " runtime library provides the following functions:\n\n\n")

    for name in func_names:
        f.write(name + "\n")
        f.write("-" * len(name) + "\n")
        f.write("\n")
        f.write(".. doxygenfunction:: " + name + "\n")
        f.write("   :project: uobjrtl-hw\n")
        f.write("\n")
        f.write("\n")

print("Finished generating documentation.")
print("Please open " + os.path.realpath(os.path.join(docs_path, args.abbrev + ".rst")))
print(" and add a description")