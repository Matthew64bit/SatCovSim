import os
import sys

def tleread(opName):
    satellites = []
    filepath = os.getcwd()
    filepath = filepath.removesuffix("\\py_file_handler")
    filepath = filepath + "\\data\\" + opName + ".tle"

    with open(filepath, "r") as f:
        line1 = f.readline()
        line2 = f.readline()
        line3 = f.readline()

        while line1 and line2 and line3:
            satellites.append({
                'name': line1.strip(),
                'tle_line_1': line2.strip(),
                'tle_line_2': line3.strip(),
            })
            line1 = f.readline()
            line2 = f.readline()
            line3 = f.readline()
    f.close()
    return satellites


def tlewrite(satellites, opName):
    filepath = os.getcwd()
    filepath = filepath.removesuffix("\\py_file_handler")
    filepath = filepath + "\\data\\" + opName + "_trimmed.tle"

    with open(filepath, "w") as f:
        for sat in satellites:
            f.write(f"{sat['name']}\n{sat['tle_line_1']}\n{sat['tle_line_2']}\n")

    f.close()


def main(opname):
    satellites = tleread(opname)

    if opname == "starlink":
        visAngle = 10
        minLat = 43.9372 - visAngle
    else:
        minLat = 0

    usable_satellites = []

    for idx, sat in enumerate(satellites):
        inclination = float(sat["tle_line_2"].split()[2])
        second_time_derivative = float(sat["tle_line_1"].split()[5][0]);
        if inclination >= minLat and second_time_derivative == 0:
            usable_satellites.append(sat)

    tlewrite(usable_satellites, opname)


if __name__ == "__main__":
    opName = sys.argv[1]
    main(opName)
