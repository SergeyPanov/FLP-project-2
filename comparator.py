import os
OUTPUTS = "./graphs/outputs/"
VALIDS = "./graphs/valids/"

OUTPUT_EXT = ".out"

def readFile(path):
    lines = []
    with open(path, "r") as f:
        lines = f.readlines()
    return lines

def compare():
    outputs = os.listdir(OUTPUTS)
    valids = os.listdir(VALIDS)

    for output_file in outputs:
        output_content = readFile(OUTPUTS + output_file)
        valid_content = readFile(VALIDS + output_file)

        for out_graph in output_content:
            edges = out_graph.split(" ")



    pass

if __name__ == '__main__':
    if os.path.exists(OUTPUTS) and os.path.exists(VALIDS):
        compare()